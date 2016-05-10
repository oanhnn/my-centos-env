#!/usr/bin/bash
# This script automatically installs and configures MariaDB 10.
echo ">> Install and config MariaDB"

[[ -z $1 ]] && { echo "!!! MariaDB root password not set. Check the Vagrant file."; exit 1; }

# copy repo file
if [ -f /etc/yum.repos.d/mariadb.repo ]
then
sudo cat > /etc/yum.repos.d/mariadb.repo <<'EOF'
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
fi

# update
sudo yum -y -q update

# install mariadb
sudo yum -y -q install mariadb-server mariadb

# ensure it is running
sudo systemctl start mariadb

# set to auto start
sudo systemctl enable mariadb

# set root password
sudo /usr/bin/mysqladmin -u root password "$1"

# enable remote access
# setting the mysql bind-address to allow connections from everywhere
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

MYSQL=`which mysql`

# allow remote access (required to access from our private network host. Note that this is completely insecure if used in any other way)
$MYSQL -u root -p$1 -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$1' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# drop the anonymous users
$MYSQL -u root -p$1 -e "DROP USER ''@'localhost';"
$MYSQL -u root -p$1 -e "DROP USER ''@'$(hostname)';"

# drop the demo database
$MYSQL -u root -p$1 -e "DROP DATABASE IF EXISTS test;"

# restart
sudo systemctl restart mariadb

#!/usr/bin/bash
# This script automatically installs and configures MariaDB 10.
echo ">> Install and config MariaDB"

[[ -z "$cf_mariadb_root_password" ]] && { echo "!!! MariaDB root password not set. Check the Vagrant file."; exit 1; }

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
sudo yum -y -q update >/dev/null 2>&1

# install mariadb
sudo yum -y -q install mariadb-server mariadb >/dev/null 2>&1

# ensure it is running
sudo systemctl start mariadb

# set to auto start
sudo systemctl enable mariadb

# set root password
echo ">> Change MariaDB root password"
sudo /usr/bin/mysqladmin -u root password "$cf_mariadb_root_password"

MYSQL=`which mysql`

# allow remote access (required to access from our private network host. Note that this is completely insecure if used in any other way)
$MYSQL -u root -p$cf_mariadb_root_password -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$cf_mariadb_root_password' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# drop the anonymous users
$MYSQL -u root -p$cf_mariadb_root_password -e "DROP USER ''@'localhost';"
$MYSQL -u root -p$cf_mariadb_root_password -e "DROP USER ''@'$(hostname)';"

# drop the demo database
$MYSQL -u root -p$cf_mariadb_root_password -e "DROP DATABASE IF EXISTS test;"

# TODO: change port for MariaDB
#sudo sed -i "s/port.*/port = ${cf_mariadb_port}/" /etc/mysql/my.cnf

# setting the mysql bind-address to allow connections from everywhere
if [[ $cf_mariadb_remote_access == true ]]
then
  echo ">> Enable access MariaDB from remote"
  sudo sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
fi

# restart
sudo systemctl restart mariadb

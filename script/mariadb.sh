#!/bin/bash
echo ">> Install MariaDB"

[[ -z "$cf_mariadb_root_password" ]] && { echo "!!! MariaDB root password not set. Check the Vagrant file."; exit 1; }

# copy repo file
if [[ ! -f /etc/yum.repos.d/mariadb.repo ]]
then
    sudo cp -f /vagrant/etc/yum.repos.d/mariadb.repo /etc/yum.repos.d/
    sudo yum -y update
fi

# Install MariaDB
sudo yum -y install mariadb-server mariadb

# Start and enable mysql service
sudo systemctl start mysql
sudo systemctl enable mysql

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

# unset MYSQl variable
unset MYSQL

# TODO change port for MariaDB
#echo ">> Change MariaDB access port to ${cf_mariadb_port}"
#sudo sed -i "s/^port\s*=.*/port = ${cf_mariadb_port}/" /etc/my.cnf

# setting the mysql bind-address to allow connections from everywhere
if [[ $cf_mariadb_remote_access == true ]]
then
  echo ">> Enable access MariaDB from remote"
  sudo sed -i "s/bind-address\s*=.*/bind-address = 0.0.0.0/" /etc/my.cnf
  sudo firewall-cmd --permanent --add-port=$cf_mariadb_port/tcp
  sudo firewall-cmd --reload
fi

# restart
sudo systemctl restart mysql

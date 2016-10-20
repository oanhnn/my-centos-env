#!/bin/bash
echo ">> Install PostgreSQL"
sudo rpm -Uvh http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
sudo yum update -y
sudo yum install -y postgresql95-server postgresql95

# make init database
sudo /usr/pgsql-9.5/bin/postgresql95-setup initdb

# start and enable postgresql service
sudo systemctl enable postgresql-9.5
sudo systemctl start postgresql-9.5

#echo ">> Install extensions"
#sudo yum install -y postgis2_95 ogr_fdw95 pgrouting_95

# TODO change port for PostgreSQL
#echo ">> Change PostgreSQL access port to ${cf_postgre_port}"
#sudo sed -i "s/^port\s*=.*/port = ${cf_postgre_port}/" /etc/my.cnf

# setting the mysql bind-address to allow connections from everywhere
if [[ $cf_mariadb_remote_access == true ]]
then
  echo ">> Enable access PostgreSQL from remote"
  #sudo sed -i "s/bind-address\s*=.*/bind-address = 0.0.0.0/" /etc/my.cnf
  sudo firewall-cmd --permanent --add-port=$cf_postgre_port/tcp
  sudo firewall-cmd --reload
fi

sudo systemctl restart postgresql-9.5

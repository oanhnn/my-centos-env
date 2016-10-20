#!/bin/bash
echo ">> Install Apache"
sudo yum -y install httpd

# ensure it is running
sudo systemctl start httpd
sudo systemctl enable httpd

echo ">> Config Apache"
# TODO Config Apache

# TODO enable https
if [[ $cf_https_enabled == true ]]
then
  echo ">> Enable HTTPS"
  #sudo cp -f /vagrant/etc/httpd/site.d/default-ssl.conf /etc/httpd/site.d/default-ssl.conf
  #sudo sed -i "s/443\sdefault_server/$cf_https_port default_server/g" /etc/default/site.d/default-ssl.conf
  sudo firewall-cmd --permanent --add-port=$cf_https_port/tcp
fi
#!/usr/bin/bash

# Config firewall
sudo firewall-cmd --permanent --add-port=$cf_http_port/tcp
sudo firewall-cmd --reload

# TODO Add basic authenticate
if [[ $cf_basic_auth_enabled == true ]]
then
  echo ">> Enable basic authenticate"
  sudo htpasswd -cb /etc/httpd/.htpasswd $cf_basic_auth_user $cf_basic_auth_password
  #sudo cp -f /vagrant/etc/httpd/default.d/basic-auth.conf /etc/httpd/default.d/basic-auth.conf
fi

# Restart service
sudo systemctl restart httpd

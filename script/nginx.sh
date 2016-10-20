#!/bin/bash
echo ">> Install NGINX"
sudo yum install -y nginx httpd-tools

# ensure it is running
sudo systemctl start nginx
sudo systemctl enable nginx

echo ">> Config NGINX"
sudo mkdir -p /etc/nginx/conf.d /etc/nginx/default.d /etc/nginx/site.d
sudo cp -f /vagrant/etc/nginx/nginx.conf /etc/nginx/nginx.conf && \
sudo cp -f /vagrant/etc/nginx/conf.d/php-fpm.conf /etc/nginx/conf.d/php-fpm.conf && \
sudo cp -f /vagrant/etc/nginx/default.d/php-fpm.conf /etc/nginx/default.d/php-fpm.conf && \
sudo cp -f /vagrant/etc/nginx/site.d/default.conf /etc/nginx/site.d/default.conf

# Modify NGINX
sudo sed -i "s/server\s127.0.0.1:9000;.*/server $cf_php_fpm_listen;/" /etc/nginx/conf.d/php-fpm.conf && \
sudo sed -i "s/^user\snginx;.*/user $cf_http_user $cf_http_group;/" /etc/nginx/nginx.conf && \
sudo sed -i "s/80\sdefault_server/$cf_http_port default_server/g" /etc/nginx/site.d/default.conf

# enable https
if [[ $cf_https_enabled == true ]]
then
  echo ">> Enable HTTPS"
  sudo cp -f /vagrant/etc/nginx/site.d/default-ssl.conf /etc/nginx/site.d/default-ssl.conf
  sudo sed -i "s/443\sdefault_server/$cf_https_port default_server/g" /etc/nginx/site.d/default-ssl.conf
  sudo firewall-cmd --permanent --add-port=$cf_https_port/tcp
fi

# Config firewall
sudo firewall-cmd --permanent --add-port=$cf_http_port/tcp
sudo firewall-cmd --reload

# Add basic authenticate
if [[ $cf_basic_auth_enabled == true ]]
then
  echo ">> Enable basic authenticate"
  sudo htpasswd -cb /etc/nginx/.htpasswd $cf_basic_auth_user $cf_basic_auth_password
  sudo cp -f /vagrant/etc/nginx/default.d/basic-auth.conf /etc/nginx/default.d/basic-auth.conf
fi

# Restart service
sudo systemctl restart nginx

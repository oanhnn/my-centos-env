#!/usr/bin/bash
echo ">> Install NGINX"
sudo yum install --enablerepo=remi -y -q nginx httpd-tools >/dev/null 2>&1

# ensure it is running
sudo systemctl start nginx

# set to auto start
sudo systemctl enable nginx

echo ">> Config NGINX"
# Copy NGINX config files
sudo mkdir -p /etc/nginx/conf.d /etc/nginx/default.d /etc/nginx/site.d
sudo cp -f /vagrant/conf/nginx/nginx.conf /etc/nginx/nginx.conf && \
sudo cp -f /vagrant/conf/nginx/php-fpm.conf /etc/nginx/conf.d/php-fpm.conf && \
sudo cp -f /vagrant/conf/nginx/default.conf /etc/nginx/default.d/default.conf && \
sudo cp -f /vagrant/conf/nginx/vhost.conf /etc/nginx/site.d/default.conf

# Modify NGINX and PHP-FPM config files
sudo sed -i "s/^listen\s*=.*/listen = $cf_php_fpm_listen/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^user\s*=.*/user = $cf_php_fpm_user/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^group\s*=.*/group = $cf_php_fpm_group/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/server\s127.0.0.1:9000;.*/server $cf_php_fpm_listen;/" /etc/nginx/conf.d/php-fpm.conf && \
sudo sed -i "s/^user\snginx;.*/user $cf_http_user $cf_http_group;/" /etc/nginx/nginx.conf && \
sudo sed -i "s/80\sdefault_server/$cf_http_port default_server/g" /etc/nginx/site.d/default.conf

# enable https
if [[ $cf_https_enabled == true ]]
then
  echo ">> Enable HTTPS"
  sudo cp -f /vagrant/conf/nginx/vhost-ssl.conf /etc/nginx/site.d/default-ssl.conf
  sudo sed -i "s/80\sdefault_server/$cf_http_port default_server/g" /etc/nginx/site.d/default-ssl.conf && \
  sudo sed -i "s/443\sdefault_server/$cf_https_port default_server/g" /etc/nginx/site.d/default-ssl.conf
fi

# Add basic authenticate
if [[ $cf_basic_auth_enabled == true ]]
then
  echo ">> Enable basic authenticate"
  sudo htpasswd -cb /etc/nginx/.htpasswd $cf_basic_auth_user $cf_basic_auth_password >/dev/null 2>&1
  sudo cp -f /vagrant/conf/nginx/basic-auth.conf /etc/nginx/default.d/basic-auth.conf
fi

# Restart service
sudo systemctl restart php-fpm && \
sudo systemctl restart nginx

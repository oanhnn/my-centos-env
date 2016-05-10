#!/usr/bin/bash
echo ">> Install NGINX"
sudo yum install --enablerepo=remi -y -q nginx

# ensure it is running
sudo systemctl start nginx

# set to auto start
sudo systemctl enable nginx

echo ">> Config NGINX"
# Config PHP-FPM
sudo sed -i '/^listen = /clisten = 127.0.0.1:9000' /etc/php-fpm.d/www.conf && \
sudo sed -i '/^user = /cuser = nginx' /etc/php-fpm.d/www.conf && \
sudo sed -i '/^group = /cgroup = nginx' /etc/php-fpm.d/www.conf

# Config NGINX
sudo mkdir -p /etc/nginx/conf.d /etc/nginx/default.d /etc/nginx/site.d && \
sudo cp -f /vagrant/conf/nginx/nginx.conf /etc/nginx/nginx.conf && \
sudo cp -f /vagrant/conf/nginx/php-fpm.conf /etc/nginx/conf.d/php-fpm.conf && \
sudo cp -f /vagrant/conf/nginx/default.conf /etc/nginx/default.d/default.conf && \
sudo cp -f /vagrant/conf/nginx/vhost.conf /etc/nginx/site.d/default.conf && \
sudo systemctl restart php-fpm && \
sudo systemctl restart nginx

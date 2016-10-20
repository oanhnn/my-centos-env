#!/bin/bash
echo ">> Install PHP 5.6"
sudo yum install --enablerepo=remi,remi-php56 -y php-cli php-fpm \
    php-pdo php-mysqlnd php-xml php-pgsql php-gd php-mcrypt \
    php-ldap php-imap php-soap php-mbstring php-intl php-pear \
    php-pecl-memcached php-pecl-mongo php-pecl-event php-pecl-redis

# start and enable php-fpm service
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

echo ">> Configure and secure PHP"
sudo sed -i "s/^;date\.timezone\s*=.*/date.timezone=$cf_timezone/" /etc/php.ini && \
sudo sed -i "s/^;cgi\.fix_pathinfo\s*=.*/cgi.fix_pathinfo=0/" /etc/php.ini && \
sudo sed -i "s/^short_open_tag\s*=.*/short_open_tag=On/" /etc/php.ini && \
sudo sed -i "s/^;daemonize\s*=.*/daemonize=no/" /etc/php-fpm.conf && \
sudo sed -i "s/^listen\s*=.*/listen=$cf_php_fpm_listen/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^user\s*=.*/user=$cf_http_user/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^group\s*=.*/group=$cf_http_group/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^listen\.allowed_clients\s*=.*/listen.allowed_clients=127.0.0.1/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^;catch_workers_output\s*=.*/catch_workers_output=yes/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^php_admin_flag\[log_errors\]\s*=.*/;php_admin_flag[log_errors] =/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^php_admin_value\[error_log\]\s*=.*/;php_admin_value[error_log] =/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^;php_admin_value\[display_errors\]\s*=.*/php_admin_value[display_errors] = 'stderr'/" >> /etc/php-fpm.d/www.conf

sudo systemctl restart php-fpm

echo ">> Install Composer"
curl -sSL https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer
sudo chmod a+x /usr/bin/composer

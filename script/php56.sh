#!/usr/bin/bash
echo ">> Install PHP 5.6"
sudo yum install --enablerepo=remi,remi-php56 -y -q php-cli php-fpm \
    php-mysqlnd php-mssql php-xml php-pgsql php-gd php-mcrypt \
    php-ldap php-imap php-soap php-mbstring php-intl php-pdo \
    php-pecl-memcache php-pecl-memcached \
    php-pecl-mongo php-pecl-event php-pecl-redis \
    php-pear >/dev/null 2>&1

echo ">> Configure and secure PHP"
sudo sed -i "s/;date.timezone =.*/date.timezone = $cf_php_timezone/" /etc/php.ini && \
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini && \
sudo sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php.ini && \
sudo sed -i "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php-fpm.conf && \
sudo sed -i "s/^listen\s*=.*/listen = $cf_php_fpm_listen/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^user\s*=.*/user = $cf_php_fpm_user/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^group\s*=.*/group = $cf_php_fpm_group/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^listen.allowed_clients.*/listen.allowed_clients = 127.0.0.1/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^;catch_workers_output.*/atch_workers_output = yes/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^php_admin_flag\[log_errors\] = .*/;php_admin_flag[log_errors] =/" /etc/php-fpm.d/www.conf && \
sudo sed -i "s/^php_admin_value\[error_log\] =.*/;php_admin_value[error_log] =/" /etc/php-fpm.d/www.conf && \
echo "php_admin_value[display_errors] = 'stderr'" >> /etc/php-fpm.d/www.conf

# ensure it is running
sudo systemctl start php-fpm

# set to auto start
sudo systemctl enable php-fpm

echo ">> Install Composer"
curl -sSL https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer
sudo chmod a+x /usr/bin/composer

#!/bin/bash
echo ">> Setting server's hostname"
[[ ! -z $cf_hostname ]] && sudo hostnamectl set-hostname $cf_hostname

echo ">> Setting server's timezone"
[[ ! -z $cf_timezone ]] && sudo timedatectl set-timezone $cf_timezone

echo ">> Prevent remote access with plaintext password"
sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
sudo systemctl restart sshd

echo ">> Enable firewalld service"
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-port=22/tcp
sudo firewall-cmd --reload

if [[ $cf_selinux_enabled == true ]]
then
  echo ">> Fix SELinux"
  cd /vagrant/conf/selinux
  sudo semodule -i httpd_t.pp
  sudo semodule -e httpd_t
  sudo setsebool -P httpd_can_network_connect 1
  sudo setsebool -P httpd_can_network_connect_db 1
  sudo setsebool -P httpd_can_network_memcache 1
  sudo setsebool -P httpd_anon_write 1
  sudo setsebool -P httpd_sys_script_anon_write 1
  sudo setsebool -P httpd_unified 1
  sudo setsebool -P httpd_can_sendmail 1
  cd ~
else
  echo ">> Disable SELinux"
  sudo setenforce 0
  sudo sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/sysconfig/selinux
  sudo sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config
fi

if [[ -f /vagrant/conf/.bashrc ]]
then
  echo ">> Load customized .bashrc file"
  echo "source /vagrant/conf/.bashrc" >> /home/vagrant/.bashrc;
fi

if [[ -f /vagrant/bin/chmodr.sh ]]
then
  echo ">> Install 'chmodr' command"
  sudo cp -f /vagrant/bin/chmodr.sh /usr/bin/chmodr && \
  sudo chmod a+x /usr/bin/chmodr
fi

echo ">> Install common packages"
sudo yum install -y epel-release
sudo yum update -y
sudo yum install -y wget curl gcc gcc-c++ make git unzip tree openssl \
    gd libxml2 zlib pcre krb5 telnet nmap

echo ">> Install REMI repo"
sudo rpm -Uh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo yum update -y

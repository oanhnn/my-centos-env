#!/usr/bin/bash
echo ">> Setting hostname"
[[ ! -z $1 ]] && sudo hostnamectl set-hostname $1

echo ">> Setting server timezone"
[[ ! -z $2 ]] && sudo timedatectl set-timezone $2

echo ">> Prevent access with plaintext password"
sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
sudo systemctl restart sshd

echo ">> Load customize bashrc"
if [ -f /vagrant/conf/.bashrc ]
then
  echo "source /vagrant/conf/.bashrc" >> /home/vagrant/.bashrc;
fi

echo ">> Install epel and remi repo"
sudo yum -y -q install epel-release && \
sudo rpm -Uh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
sudo yum update -y -q

echo ">> Install common packages"
sudo yum install -y -q wget curl tar openssl-devel gcc gcc-c++ make \
    zlib-devel pcre-devel gd-devel krb5-devel git

#echo ">> Fix SELinux"
#cd /vagrant/conf/selinux && \
#sudo semodule -i httpd_t.pp && \
#sudo semodule -e httpd_t && \
#cd /home/vagrant
#sudo setsebool -P httpd_can_network_connect 1
#sudo setsebool -P httpd_can_network_connect_db 1
#sudo setsebool -P httpd_can_network_memcache 1
#sudo setsebool -P httpd_anon_write 1
#sudo setsebool -P httpd_sys_script_anon_write 1
#sudo setsebool -P httpd_unified 1
#sudo setsebool -P httpd_can_sendmail 1

echo ">> Disable SELinux"
sudo setenforce 0
sudo sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/sysconfig/selinux
sudo sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config

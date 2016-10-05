#!/usr/bin/bash
echo ">> Setting server's hostname"
[[ ! -z $cf_hostname ]] && sudo hostnamectl set-hostname $cf_hostname

echo ">> Setting server's timezone"
[[ ! -z $cf_timezone ]] && sudo timedatectl set-timezone $cf_timezone

echo ">> Prevent access with plaintext password"
sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
sudo systemctl restart sshd

echo ">> Load customized .bashrc file"
if [ -f /vagrant/conf/.bashrc ]
then
  echo "source /vagrant/conf/.bashrc" >> /home/vagrant/.bashrc;
fi

echo ">> Install 'chmodr'"
sudo cp -f /vagrant/conf/chmodr.sh /usr/bin/chmodr && \
sudo chmod a+x /usr/bin/chmodr

echo ">> Install EPEL and REMI repo"
sudo yum -y -q install epel-release >/dev/null 2>&1
sudo rpm -Uh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm >/dev/null 2>&1
sudo yum update -y -q >/dev/null 2>&1

echo ">> Install common packages"
sudo yum install -y -q wget curl tar openssl-devel gcc gcc-c++ make \
    zlib-devel pcre-devel gd-devel krb5-devel git >/dev/null 2>&1

if [[ $cf_selinux_enabled == true ]]
then
  echo ">> Fix SELinux"
  cd /vagrant/conf/selinux
  sudo semodule -i httpd_t.pp
  sudo semodule -e httpd_t
  cd /home/vagrant
  sudo setsebool -P httpd_can_network_connect 1
  sudo setsebool -P httpd_can_network_connect_db 1
  sudo setsebool -P httpd_can_network_memcache 1
  sudo setsebool -P httpd_anon_write 1
  sudo setsebool -P httpd_sys_script_anon_write 1
  sudo setsebool -P httpd_unified 1
  sudo setsebool -P httpd_can_sendmail 1
else
  echo ">> Disable SELinux"
  sudo setenforce 0
  sudo sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/sysconfig/selinux
  sudo sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config
fi

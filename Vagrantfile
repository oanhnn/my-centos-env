# -*- mode: ruby -*-
# vi: set ft=ruby :

# Your settings
################################################################################

my = {
  :cf_hostname              => "my-centos-env.dev" ,
  :cf_private_ip            => "10.10.10.10"       ,
  :cf_timezone              => "UTC"               ,
  :cf_private_key_path      => "./key/id_rsa"      ,
  :cf_public_key_path       => "./key/id_rsa.pub"  ,
  :cf_app_source_path       => "../source"         ,
  :cf_selinux_enabled       => false               ,

  :cf_http_port             => 80                  ,
  :cf_http_user             => "nginx"             ,
  :cf_http_group            => "nginx"             ,
  :cf_https_enabled         => false               ,
  :cf_https_port            => 443                 ,
  :cf_basic_auth_enabled    => true                ,
  :cf_basic_auth_user       => "dev"               ,
  :cf_basic_auth_password   => "devpass"           ,

  :cf_php_timezone          => "UTC"               ,
  :cf_php_fpm_listen        => "127.0.0.1:9000"    ,
  :cf_php_fpm_user          => "nginx"             ,
  :cf_php_fpm_group         => "nginx"             ,

  :cf_mariadb_root_password => "rootpass"          ,
  :cf_mariadb_port          => 3306                ,
  :cf_mariadb_remote_access => false               ,

  :cf_redis_port            => 6379                ,
  :cf_redis_remote_access   => false               ,
  #:cf_redis_password        => false               ,
  :cf_host_port_ssh         => 20022               ,
  :cf_host_port_http        => 20080               ,
  :cf_host_port_https       => 20443               ,
  :cf_host_port_mariadb     => 23306               ,
  :cf_host_port_redis       => 26379               ,
}

################################################################################

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.box_version = "=1603.01"

  config.vm.network "forwarded_port", guest: 22,                   host: my[:cf_host_port_ssh], id: "ssh"
  config.vm.network "forwarded_port", guest: my[:cf_http_port],    host: my[:cf_host_port_http], id: "http"
  config.vm.network "forwarded_port", guest: my[:cf_https_port],   host: my[:cf_host_port_https], id: "https", disabled: my[:cf_https_enabled]
  config.vm.network "forwarded_port", guest: my[:cf_mariadb_port], host: my[:cf_host_port_mariadb], id: "mysql"
  config.vm.network "forwarded_port", guest: my[:cf_redis_port],   host: my[:cf_host_port_redis], id: "redis"
  config.vm.network "private_network", ip: my[:cf_private_ip]

  config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true
  config.vm.synced_folder ".", "/vagrant", id:"core"
  config.vm.synced_folder my[:cf_app_source_path], "/app/source", mount_options: ["dmode=775,fmode=775"]

  # Using existed private key and do not generate a key
  config.ssh.insert_key = false
  config.ssh.private_key_path = [my[:cf_private_key_path], "~/.vagrant.d/insecure_private_key"]

  # Auto update vbguest if plugin "vagrant-vbguest" is installed
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = true
  end

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    vb.name = my[:cf_hostname]
    # Customize the amount of memory on the VM:
    vb.cpus = 1
    vb.memory = "1024"
  end

  # Copy public key to VM
  config.vm.provision "file", source: my[:cf_public_key_path], destination: "~/.ssh/authorized_keys"
  config.vm.provision "shell", path: "./script/base.sh",    env: my
  config.vm.provision "shell", path: "./script/mariadb.sh", env: my
  config.vm.provision "shell", path: "./script/php56.sh",   env: my
  config.vm.provision "shell", path: "./script/nginx.sh",   env: my
  config.vm.provision "shell", path: "./script/redis.sh",   env: my
  config.vm.provision "shell", path: "./script/nodejs.sh",  env: my

end

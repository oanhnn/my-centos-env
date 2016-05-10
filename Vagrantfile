# -*- mode: ruby -*-
# vi: set ft=ruby :

# Your config
################################################################################
my_hostname              = "my-centos-env.dev"
my_timezone              = "UTC"
my_private_key_path      = "./key/id_rsa"
my_public_key_path       = "./key/id_rsa.pub"
my_app_source_path       = "../source"
my_http_port             = 80
my_https_port            = 443
#my_https_enabled         = false

#my_php_timezone          = "UTC"
#my_php_fpm_listen        = "127.0.0.1:9000"
#my_php_fpm_user          = "nginx"
#my_php_fpm_group         = "nginx"

my_mariadb_root_password = "rootpass"
my_mariadb_port          = 3306
#my_mariadb_remote_access = false

my_redis_port            = 6379
#my_redis_remote_access   = false
#my_redis_password        = nil
################################################################################

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.box_version = "=1603.01"

  config.vm.network "forwarded_port", guest: 22,              host: 20022, id: "ssh"
  config.vm.network "forwarded_port", guest: my_http_port,    host: 20080, id: "http"
  config.vm.network "forwarded_port", guest: my_https_port,   host: 20443, id: "https"
  config.vm.network "forwarded_port", guest: my_mariadb_port, host: 23306, id: "mysql"
  config.vm.network "forwarded_port", guest: my_redis_port,   host: 26379, id: "redis"
  config.vm.network "private_network", ip: "10.10.10.10"

  config.vm.synced_folder ".", "/vagrant", id:"core"
  config.vm.synced_folder my_app_source_path, "/app/source"

  # Using existed private key and do not generate a key
  config.ssh.insert_key = false
  config.ssh.private_key_path = [my_private_key_path, "~/.vagrant.d/insecure_private_key"]

  # Auto update vbguest if plugin "vagrant-vbguest" is installed
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = true
  end

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    vb.name = my_hostname
    # Customize the amount of memory on the VM:
    vb.cpus = 1
    vb.memory = "1024"
  end

  # Copy public key to VM
  config.vm.provision "file", source: my_public_key_path, destination: "~/.ssh/authorized_keys"
  config.vm.provision "shell", path: "./script/base.sh",    args: [my_hostname, my_timezone]
  config.vm.provision "shell", path: "./script/mariadb.sh", args: [my_mariadb_root_password]
  config.vm.provision "shell", path: "./script/php56.sh"
  config.vm.provision "shell", path: "./script/nginx.sh"
  config.vm.provision "shell", path: "./script/redis.sh",   args: [my_redis_port]
  config.vm.provision "shell", path: "./script/nodejs.sh"

end

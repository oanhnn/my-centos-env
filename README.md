My CentOS environment
===
A vagrant template to create CentOS VM for development environment

Features
---

- [x] Using [CentOS 7.2][boxversion]
- [x] Auto install php-fpm v5.6
- [x] Auto install NGINX v1.6
- [x] Auto install MariaDB v5.5
- [x] Auto install Redis v2.8
- [x] Auto install NodeJS v4.x
- [x] Config is editable

Requirements
---

- [Vagrant][vagrant] 1.8+
- [Virtual Box][virtualbox] 5.0+

Installation
---

1. Download latest version in [here][archive]
2. Edit your settings in `Vagrantfile` file

   ```ruby
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
   }
   ```

3. Run `vagrant up` and waiting

Usage
---

1. Remote access by `vagrant ssh`

   ```
   $ vagrant ssh
   ```

Contributing
---
All code contributions must go through a pull request and approved by a core developer
before being merged. This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues][issues].

License
---
This project is released under the MIT License.   
Copyright © 2016 [Oanh Nguyen][mypage]

[vagrant]:    https://www.vagrantup.com/downloads.html
[virtualbox]: https://www.virtualbox.org/wiki/Downloads
[boxversion]: https://atlas.hashicorp.com/centos/boxes/7/versions/1603.01
[archive]:    https://github.com/oanhnn/my-centos-env/archive/master.zip
[issues]:     https://github.com/oanhnn/my-centos-env/issues
[mypage]:     https://oanhnn.github.io

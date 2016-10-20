My CentOS environment
===
A vagrant template to create CentOS VM for development environment

Features
---

- [x] Using [CentOS 7.2][boxversion]
- [x] Auto install php-fpm v5.6
- [x] Auto install NGINX v1.10
- [ ] Auto install Apache (httpd) v2.4
- [x] Auto install MariaDB v10.0
- [ ] Auto install PostgreSQL v9.5
- [x] Auto install Redis v2.8
- [x] Auto install NodeJS v4.x
- [ ] Auto install JDK v8
- [x] May be customize configuration
- [x] Protected web by basic authentication

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
     # basic configuration
     :cf_hostname              => "my-centos-env.dev" ,
     :cf_private_ip            => "10.10.10.10"       ,
     :cf_timezone              => "UTC"               ,
     :cf_private_key_path      => "./key/id_rsa"      ,
     :cf_public_key_path       => "./key/id_rsa.pub"  ,
     :cf_app_source_path       => "../source"         ,
     :cf_selinux_enabled       => false               ,

     # configuration for nginx or httpd service
     :cf_http_port             => 80                  ,
     :cf_http_user             => "apache"            ,
     :cf_http_group            => "apache"            ,
     :cf_https_enabled         => false               ,
     :cf_https_port            => 443                 ,

     # configuration for basic authentication
     :cf_basic_auth_enabled    => true                ,
     :cf_basic_auth_user       => "dev"               ,
     :cf_basic_auth_password   => "devpass"           ,

     # configuration for php-fpm service
     :cf_php_fpm_listen        => "127.0.0.1:9000"    ,

     # configuration for mysqld service
     :cf_mariadb_root_password => "rootpass"          ,
     :cf_mariadb_port          => 3306                ,
     :cf_mariadb_remote_access => true                ,

     # configuration for postgresql service
     :cf_postgresql_port          => 5432             ,
     :cf_postgresql_remote_access => true             ,

     # configuration for redis-server service
     :cf_redis_port            => 6379                ,
     :cf_redis_remote_access   => false               ,
     #:cf_redis_password        => false               ,

     # configuration for forwarded_port
     :cf_host_port_ssh         => 20022               ,
     :cf_host_port_http        => 20080               ,
     :cf_host_port_https       => 20443               ,
     :cf_host_port_mariadb     => 23306               ,
     :cf_host_port_postgresql  => 25432               ,
     :cf_host_port_redis       => 26379               ,
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

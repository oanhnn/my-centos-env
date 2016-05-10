My CentOS environment
===
A vagrant template to create CentOS VM for development environment

Features
---

- [x] [CentOS 7.2][boxversion]
- [x] php-fpm v5.6
- [x] NGINX
- [x] MariaDB
- [x] Redis 2.8
- [x] NodeJS

Requirements
---

- vagrant 1.8+
- virtualbox 5.0+

Installation
---

1. Download latest version in [here][archive]
2. Edit your setting in `Vagrantfile` file
3. Run `vagrant up` and waiting

Usage
---

1. Remote access by `vagrant ssh`

   ```
   $ vagrant ssh
   ```

Contributing
---
All code contributions must go through a pull request and approved by
a core developer before being merged. This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues][issues].

License
---
This project is released under the MIT License.
Copyright © 2016 [Oanh Nguyen][mypage]

[boxversion]: https://atlas.hashicorp.com/centos/boxes/7/versions/1603.01
[archive]:    https://github.com/oanhnn/my-centos-env/archive/master.zip
[issues]:     https://github.com/oanhnn/my-centos-env/issues
[mypage]:     https://oanhnn.github.io

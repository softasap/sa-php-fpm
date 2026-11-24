sa_php_fpm
==========
[![CI](https://github.com/softasap/sa-php-fpm/actions/workflows/ci.yml/badge.svg)](https://github.com/softasap/sa-php-fpm/actions/workflows/ci.yml)


Basic role for php-fpm install, optional pre-configured xdebug support, optional global composer installation as composer{{php_version}}

On Ubuntu, non-default and older PHP families (5.6, 7.x, 8.x) are installed from
[packages.sury.org](https://packages.sury.org/php/) (successor of the deprecated
`ppa:ondrej/php`); on Debian the
distro-provided PHP is used (`php_family: default`).


Example of usage:

Simple

```YAML

     - {
         role: "sa_php_fpm"
       }


```

Advanced

see box-example for full featured lamp install.

```YAML

     - {
         role: "sa_php_fpm",
         option_install_xdebug: true,
         php_xdebug_version: 2.5.5,
         xdebug_remote_enable: 1
         # IMPORTANT - SETTING BELOW TO 1 ON PROD SERVERS RESULTS TO EXPLOIT
         # AS  xdebug_remote_host is ignored
         xdebug_remote_connect_back: 0
         xdebug_remote_host: "127.0.0.1"


         option_install_composer: true,         

         php_fpm_user: www-data,
         php_fpm_group: www-data,

         php_fpm_listen: sock, # tcp 9000 to support. and both
         php_family: default, #  5.6 | 7.0 ... 7.4 | 8.0 ... 8.5 | hhvm | default

         pkg_dependencies:
           - git
           - curl
           - unzip

         php_extensions:
           - "{{php_module_prefix}}-mysql"
           - "{{php_module_prefix}}-intl"
           - "{{php_module_prefix}}-curl"
           - "{{php_module_prefix}}-gd"

         timezone: "Europe/London",

         custom_pool_properties:
           - {regexp: "^[;]?listen.owner *", line: "listen.owner  = {{php_fpm_user}}"}
           - {regexp: "^[;]?listen.group *", line: "listen.group  = {{php_fpm_group}}"}

       }


```


Usage with ansible galaxy workflow
----------------------------------

If you installed the `sa_php_fpm` role using the command


`
   ansible-galaxy install softasap.sa_php_fpm
`

the role will be available in the folder `library/softasap.sa_php_fpm`
Please adjust the path accordingly.

```YAML

     - {
         role: "softasap.sa_php_fpm"
       }

```




Copyright and license
---------------------

Code is dual licensed under the [BSD 3 clause] (https://opensource.org/licenses/BSD-3-Clause) and the [MIT License] (http://opensource.org/licenses/MIT). Choose the one that suits you best.

Reach us:

Subscribe for roles updates at [FB] (https://www.facebook.com/SoftAsap/)

Join gitter discussion channel at [Gitter](https://gitter.im/softasap)

Discover other roles at  http://www.softasap.com/roles/registry_generated.html

visit our blog at http://www.softasap.com/blog/archive.html

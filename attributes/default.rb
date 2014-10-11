# Default Attributes For Appsindo Cookbook
default['phpredis']['revision'] = 'master'

# NTP
default['ntp']['servers'] = ['0.pool.ntp.org', '1.pool.ntp.org']

# MYSQL
default['mysql']['service_name']           = 'default'
default['mysql']['server_root_password']   = 'ilikerandompasswords'
default['mysql']['server_debian_password'] = 'postinstallscriptsarestupid'
default['mysql']['data_dir']               = '/var/lib/mysql'
default['mysql']['port']                   = '3306'

default['mysql']['allow_remote_root']      = false
default['mysql']['remove_anonymous_users'] = true
default['mysql']['root_network_acl']       = nil

# PHP
default['php']['fpm_user']      = 'www-data'
default['php']['fpm_group']     = 'www-data'
default['php']['install_method'] = 'source'
default['php']['url']            = 'http://us1.php.net/get'
default['php']['version']        = '5.5.9'
default['php']['checksum']       = '378de162efdaeeb725ed38d7fe956c9f0b9084ff'
default['php']['prefix_dir']     = '/usr/local'
default['php']['configure_options'] = %W{--prefix=#{php['prefix_dir']}
                                         --with-libdir=#{lib_dir}
                                         --with-config-file-path=#{php['conf_dir']}
                                         --with-config-file-scan-dir=#{php['ext_conf_dir']}
                                         --with-pear
                                         --enable-fpm
                                         --with-fpm-user=#{php['fpm_user']}
                                         --with-fpm-group=#{php['fpm_group']}
                                         --with-zlib
                                         --with-openssl
                                         --with-kerberos
                                         --with-bz2
                                         --with-curl
                                         --enable-ftp
                                         --enable-zip
                                         --enable-exif
                                         --with-gd
                                         --enable-gd-native-ttf
                                         --with-gettext
                                         --with-gmp
                                         --with-mhash
                                         --with-iconv
                                         --with-imap
                                         --with-imap-ssl
                                         --enable-sockets
                                         --enable-soap
                                         --with-xmlrpc
                                         --with-libevent-dir
                                         --with-mcrypt
                                         --enable-mbstring
                                         --with-t1lib
                                         --with-mysql
                                         --with-mysqli=/usr/bin/mysql_config
                                         --with-mysql-sock
                                         --with-sqlite3
                                         --with-pdo-mysql
                                         --with-pdo-sqlite}

# Nginx
default['nginx']['source']['version']   = '1.6.2'
default['nginx']['source']['prefix']    = "/etc/nginx"
default['nginx']['dir']                 = '/etc/nginx'
default['nginx']['source']['conf_path'] = "#{node['nginx']['dir']}/nginx.conf"
default['nginx']['source']['sbin_path'] = "#{node['nginx']['source']['prefix']}/sbin/nginx"
default['nginx']['source']['default_configure_flags'] = %W(
  --prefix=#{node['nginx']['source']['prefix']}
  --conf-path=#{node['nginx']['dir']}/nginx.conf
  --sbin-path=#{node['nginx']['source']['sbin_path']}
  --pid-path=/var/run/nginx.pid
  --lock-path=/var/run/nginx.lock
  --error-log-path=/var/log/nginx/error.log
  --http-log-path=/var/log/nginx/access.log
  --http-client-body-temp-path=/var/lib/nginx/body
  --http-proxy-temp-path=/var/lib/nginx/proxy
  --http-fastcgi-temp-path=/var/lib/nginx/fastcgi
  --user=www-data
  --group=www-data
  --without-http_autoindex_module
  --without-http_memcached_module
  --with-http_ssl_module
  --with-http_gzip_static_module
  --with-http_spdy_module
  --with-pcre
  --with-ipv6
  --add-module=/tmp/ngx_pagespeed
  --without-http_auth_basic_module
  --without-http_geo_module
  --without-http_ssi_module
  --without-http_uwsgi_module
  --without-mail_pop3_module
  --without-mail_imap_module
  --without-mail_smtp_module
)

default['nginx']['configure_flags']    = []
default['nginx']['source']['version']  = '1.6.2'
default['nginx']['source']['url']      = "http://nginx.org/download/nginx-#{node['nginx']['source']['version']}.tar.gz"
default['nginx']['source']['checksum'] = 'f5cfe682a1aeef4602c2ca705402d5049b748f946563f41d8256c18674836067'
default['nginx']['source']['modules']  = %w(
  nginx::http_ssl_module
  nginx::http_gzip_static_module
)
default['nginx']['source']['use_existing_user'] = false
#
# Cookbook Name:: appsindo
# Recipe:: nginx
# Author:: Erwin Saputra <erwin.saputra@at.co.id>
#
#   Install nginx
#
#
# Copyright 2013, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
#
#

# download pagespeed
git "/tmp/ngx_pagespeed" do
    repository "git://github.com/pagespeed/ngx_pagespeed.git"
    reference "master"
    action :sync
end

# download psol
bash "make & install pagespeed SOL for nginx" do
  cwd  "/tmp/ngx_pagespeed"
  code <<-EOF
  wget https://dl.google.com/dl/page-speed/psol/1.9.32.1.tar.gz
  tar -xzvf 1.9.32.1.tar.gz
  EOF
end

# prepare tmp for nginx
directory "/var/tmp/nginx/" do
  owner  "root"
  group  "root"
  mode   0755
  action :create
end

directory "/var/tmp/nginx/client/" do
  owner  "root"
  group  "root"
  mode   0755
  action :create
end

directory "/var/tmp/pagespeed/" do
  owner  "root"
  group  "root"
  mode   0775
  action :create
end

directory "/var/tmp/nginx/proxy/" do
  owner  "root"
  group  "root"
  mode   0755
  action :create
end

directory "/var/tmp/nginx/fcgi/" do
  owner  "root"
  group  "root"
  mode   0755
  action :create
end

include_recipe "nginx"

is_dev = "";
if node.default["environment"] == "development"
  is_dev = ".dev"
end

#---------------------------- Basic Includes
directory "/etc/nginx/appsindo.d" do
  action    :delete
  recursive true
end

# create /etc/nginx/appsindo.d for default includes
directory "/etc/nginx/appsindo.d" do
  owner  "root"
  group  "root"
  mode   0755
  action :create
end

%w{
   apps.cachebust
   apps.chrome.conf
   apps.cors-insecure.conf
   apps.expirity.conf
   apps.no-transform.conf
   apps.opt.conf
   apps.pagespeed.conf
   apps.security.conf
   apps.spdy.conf
   apps.ssl.conf
   apps.ssl_stapling.conf
   apps.yii.conf
   apps.yii2.conf
}.each do |file|
    # copy basic `.conf` to include later
    cookbook_file "/etc/nginx/appsindo.d/#{file}" do
      source  "nginx/appsindo.d/#{file}#{is_dev}"
      mode    0644
      owner   "root"
      group   "root"
      action  :create_if_missing
    end
end

#---------------------------- Custom Errors
directory "/etc/nginx/errors.d/" do
  owner   "root"
  group   "root"
  mode    0755
  action  :create
end

%w{404 403 500 503}.each do |file|
    cookbook_file "/etc/nginx/errors.d/#{file}.html" do
      source  "nginx/errors.d/nginx-#{file}.html"
      mode    0644
      owner   "root"
      group   "root"
      action  :create_if_missing
    end
end

# Mime
cookbook_file "/etc/nginx/mime.types" do
  source "nginx/mime.types#{is_dev}"
  mode 0644
  owner "root"
  group "root"
  action :create
end

# create `/etc/nginx/sites-available/`
directory "/etc/nginx/sites-available/" do
  owner  "root"
  group  "root"
  mode   0755
  action :create
end

# create `/etc/nginx/sites-enabled/`
directory "/etc/nginx/sites-enabled/" do
  owner  "root"
  group  "root"
  mode   0755
  action :create
end

# SNI limiter
cookbook_file "/etc/nginx/sites-available/00-default" do
  source "nginx/00-default#{is_dev}"
  mode   0644
  owner  "root"
  group  "root"
  action :create_if_missing
end

# Default Landing
directory "/var/www/default/logs" do
  owner      "root"
  group      "www-data"
  mode       0775
  recursive  true
  action     :create
end

cookbook_file "/var/www/default/index.html" do
  source "nginx/nginx-default-index.html"
  mode   0655
  owner  "root"
  group  "www-data"
  action :create_if_missing
end

cookbook_file "/var/www/default/info.php" do
  source "nginx/nginx-default-info.php"
  mode   0655
  owner  "root"
  group  "www-data"
  action :create_if_missing
end

appsindo_ngapp 'localhost' do
   root_path   '/var/www/default'
   server_name 'localhost'
   force_https false
   https       false
   app_type    'php-fpm'
   pass        'unix:/var/run/php5-fpm.sock'
end

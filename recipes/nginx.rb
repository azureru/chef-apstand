#
# Cookbook Name:: appsindo
# Recipe:: nginx
# Author:: Erwin Saputra <erwin.saputra@at.co.id>
#
#   Install nginx
#
# Copyright 2013, Appsindo Technology
#
# All rights reserved - Do Not Redistribute
#

# download pagespeed
git "/tmp/ngx_pagespeed" do
    repository "git://github.com/pagespeed/ngx_pagespeed.git"
    reference "master"
    action :sync
end

include_recipe "nginx"

is_dev = "";
if node["environment"] == "development"
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

%w{apps.chrome.conf apps.expirity.conf apps.no-transform.conf apps.opt.conf apps.security.conf apps.yii.conf}.each do |file|
    # copy basic `.conf` to include later
    cookbook_file "/etc/nginx/appsindo.d/#{file}" do
      source  "nginx/#{file}#{is_dev}"
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
      source  "nginx/nginx-#{file}.html"
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

# SNI limit
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

webapper 'localhost' do
   enable      true
   root_path   '/var/www/default'
   force_https false
   app_type    'php-fpm'
   pass        '127.0.0.1:9000'
   https       false
end

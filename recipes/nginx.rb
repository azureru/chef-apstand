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

is_dev = "";
if node["environment"] == "development"
  is_dev = ".dev"
end

# remove all sites in `/etc/nginx/sites-available/`
directory "/etc/nginx/sites-available/" do
  action :delete
  recursive true
end

# remove all sites in `/etc/nginx/sites-enabled/`
directory "/etc/nginx/sites-enabled/" do
  action :delete
  recursive true
end

# remove /etc/nginx/appsindo.d recursively
directory "/etc/nginx/appsindo.d" do
  action :delete
  recursive true
end

# create /etc/nginx/appsindo.d with root:root 755 permission
directory "/etc/nginx/appsindo.d" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# copy basic `.conf` to include later
cookbook_file "/etc/nginx/appsindo.d/apps.chrome.conf" do
  source "apps.chrome.conf#{is_dev}"
  mode 0644
  owner "root"
  group "root"
  action :create_if_missing
end

# copy basic `.conf` to include later
cookbook_file "/etc/nginx/appsindo.d/apps.expirity.conf" do
  source "apps.expirity.conf#{is_dev}"
  mode 0644
  owner "root"
  group "root"
  action :create_if_missing
end

# copy basic `.conf` to include later
cookbook_file "/etc/nginx/appsindo.d/apps.no-transform.conf" do
  source "apps.no-transform.conf#{is_dev}"
  mode 0644
  owner "root"
  group "root"
  action :create_if_missing
end

# copy basic `.conf` to include later
cookbook_file "/etc/nginx/appsindo.d/apps.opt.conf" do
  source "apps.opt.conf#{is_dev}"
  mode 0644
  owner "root"
  group "root"
  action :create_if_missing
end

# copy basic `.conf` to include later
cookbook_file "/etc/nginx/appsindo.d/apps.security.conf" do
  source "apps.security.conf#{is_dev}"
  mode 0644
  owner "root"
  group "root"
  action :create_if_missing
end

# copy basic `.conf` to include later
cookbook_file "/etc/nginx/appsindo.d/apps.yii.conf" do
  source "apps.yii.conf#{is_dev}"
  mode 0644
  owner "root"
  group "root"
  action :create_if_missing
end

# copy basic `.conf` to include later
cookbook_file "/etc/nginx/mime.types" do
  source "mime.types#{is_dev}"
  mode 0644
  owner "root"
  group "root"
  action :create
end

# create `/etc/nginx/sites-available/`
directory "/etc/nginx/sites-available/" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# create `/etc/nginx/sites-enabled/`
directory "/etc/nginx/sites-enabled/" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# copy cookbook file for `host-limiter`
cookbook_file "/etc/nginx/sites-available/00-default" do
  source "00-default#{is_dev}"
  mode 0644
  owner "root"
  group "root"
  action :create_if_missing
end

# create `/etc/nginx/errors.d/` for custom errors
directory "/etc/nginx/errors.d/" do
  owner  "root"
  group  "root"
  mode   0755
  action :create
end

cookbook_file "/etc/nginx/errors.d/404.html" do
  source "nginx-404.html"
  mode   0644
  owner  "root"
  group  "root"
  action :create_if_missing
end

cookbook_file "/etc/nginx/errors.d/403.html" do
  source "nginx-403.html"
  mode   0644
  owner  "root"
  group  "root"
  action :create_if_missing
end

cookbook_file "/etc/nginx/errors.d/500.html" do
  source "nginx-500.html"
  mode   0644
  owner  "root"
  group  "root"
  action :create_if_missing
end

cookbook_file "/etc/nginx/errors.d/503.html" do
  source "nginx-503.html"
  mode   0644
  owner  "root"
  group  "root"
  action :create_if_missing
end

#
# default sample landing
# (so we know we have proper nginx sites)
#
directory "/var/www/default/logs" do
  owner     "root"
  group     "www-data"
  mode      0775
  recursive true
  action    :create
end

cookbook_file "/var/www/default/index.html" do
  source "nginx-default-index.html"
  mode   0655
  owner  "root"
  group  "www-data"
  action :create_if_missing
end

cookbook_file "/var/www/default/info.php" do
  source "nginx-default-info.php"
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

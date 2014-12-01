#
# Cookbook Name:: appsindo
# Recipe:: php_predis
# Descriptions::
#    Will install PHP Redis Module from Source
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

include_recipe "build-essential"
include_recipe "git"

# build dependencies
package "make" do
  action :install
end

# prepare temporary folder
directory "/tmp/phpredis" do
  owner   "root"
  group   "root"
  mode    "0755"
  action  :create
end

# clone the source code of phpredis
git "/tmp/phpredis" do
  repository "git://github.com/nicolasff/phpredis.git"
  revision   node['phpredis']['revision']
  action     :sync
  not_if     "php -m | grep redis"
end

bash "make & install phpredis" do
  cwd  "/tmp/phpredis"
  code <<-EOF
      phpize
      ./configure
      make && make install
  EOF
  not_if "php -m | grep redis"
end

template "#{node['php']['ext_conf_dir']}/redis.ini" do
  source  "php_extension.ini.erb"
  owner   "root"
  group   "root"
  mode    "0644"
  variables(:name => "redis", :directives => [])
  not_if  "php -m | grep redis"
end

link "/etc/php5/cli/conf.d/20-redis.ini" do
    to "#{node['php']['ext_conf_dir']}/redis.ini"
end

link "/etc/php5/fpm/conf.d/20-redis.ini" do
    to "#{node['php']['ext_conf_dir']}/redis.ini"
end

service "php5-fpm" do
  action :restart
end
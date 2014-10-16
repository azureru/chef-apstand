#
# Cookbook Name:: appsindo
# Recipe:: php_mongo
# Descriptions::
#    Will install PHP Mongo Module from Source
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

include_recipe "build-essential"
include_recipe "git"

# build dependencies
package "make" do
  action   :install
end

# prepare temporary folder
directory "/tmp/phpmongo" do
  owner   "root"
  group   "root"
  mode    "0755"
  action  :create
end

# clone the source code of phpredis
git "/tmp/phpmongo" do
  repository  "https://github.com/mongodb/mongo-php-driver.git"
  revision    'master'
  action      :sync
  not_if      "php -m | grep mongo"
end

bash "make & install mongo" do
  cwd   "/tmp/phpmongo"
  code <<-EOF
      phpize
      ./configure
      make && make install
  EOF
  not_if "php -m | grep mongo"
end

template "#{node['php']['ext_conf_dir']}/mongo.ini" do
  source   "php_extension.ini.erb"
  owner    "root"
  group    "root"
  mode     "0644"
  variables(:name => "mongo", :directives => [])
  not_if   "php -m | grep mongo"
end
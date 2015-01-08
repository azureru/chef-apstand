#
# Cookbook Name:: appsindo
# Recipe:: php
# Descriptions::
#
#    Will install PHP and some standard modules
#    also create php-conf pool
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

if node.default['php']['install_method'] == 'package' then
    include_recipe "appsindo::php_package"
else
    include_recipe "appsindo::php_source"
end

# create single pool config for development purpose
pool_name  = "www"
localUser  = node['www']['user']
localGroup = node['www']['group']
template "/etc/php5/fpm/pool.d/#{pool_name}.conf" do
  action   :create
  source   "pool-fpm.erb"
  cookbook "appsindo"
  mode     "764"
  owner    "root"
  group    "root"
  backup   false
  variables(
     :name  => pool_name,
     :user  => localUser,
     :group => localGroup
  )
end

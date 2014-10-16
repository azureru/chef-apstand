#
# Cookbook Name:: appsindo
# Recipe:: mysql
#
#
# Copyright 2013, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
#
#

# check for default and get angry at people for stick with the default :)
if node['mysql']['server_root_password'] == 'defaultwillthrowexception' then
    Chef::Application.fatal! "You need to specify mysql.server_root_password value on your attributes!"
end

if node['mysql']['server_debian_password'] == 'defaultwillthrowexception' then
    Chef::Application.fatal! "You need to specify mysql.server_debian_password value on your attributes!"
end

include_recipe "mysql::server"

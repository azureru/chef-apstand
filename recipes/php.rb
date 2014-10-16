#
# Cookbook Name:: appsindo
# Recipe:: php
# Descriptions::
#    Will install PHP and some standard modules
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


#
# Cookbook Name:: appsindo
# Recipe:: php
# Descriptions::
#
#    Will install PHP and some standard modules
#
# Copyright 2013, PT Appsindo Technology
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
#

# install standard issued PHP
include_recipe "php"

php_pear "apc" do
  action :install
  directives(:shm_size => 128, :enable_cli => 1)
end


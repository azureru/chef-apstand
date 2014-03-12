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

# standard modules
include_recipe "php::module_apc"
include_recipe "php::module_mysql"
include_recipe "php::module_curl"
include_recipe "php::module_gd"
include_recipe "php::module_memcache"
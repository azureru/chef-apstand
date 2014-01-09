#
# Cookbook Name:: appsindo
# Recipe:: php
#
# Copyright 2013, PT Appsindo Technology
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
# All rights reserved - Do Not Redistribute
#

# install standard issued PHP
include_recipe "php"
# include_recipe "chef-php-extra::predis"
# include_recipe "chef-php-extra::module_gd"
# include_recipe "chef-php-extra::module_imagick"
# include_recipe "chef-php-extra::module_mcrypt"
# include_recipe "chef-php-extra::module_xml"
include_recipe "php::module_apc"
include_recipe "php::module_mysql"
include_recipe "php::module_curl"
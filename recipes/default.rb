#
# Cookbook Name:: appsindo
# Recipe:: default
# Description::
#       Install default toolset that usually needed on Server
#
# Copyright 2013, PT Appsindo Technology
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt::default'
include_recipe 'build-essential'
include_recipe 'git'

%w{curl libsqlite3-dev zlib1g-dev libpcre3 libpcre3-dev unzip libxml2-utils lynx links}.each do |a_package|
  package a_package
end

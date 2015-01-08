#
# Cookbook Name:: appsindo
# Recipe:: default
# Description::
#
#       Install default toolset that usually needed on Server
#        - Install APT
#        - Install Build Essentials
#        - Install Git
#        - Install libraries needed to compile stuffs
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

# essentials
include_recipe 'apt::default'
include_recipe 'build-essential'
include_recipe 'git'

# basic dependencies for compiling things
%w{curl re2c tar libsqlite3-dev zlib1g-dev libpcre3 libpcre3-dev unzip libxml2-utils}.each do |a_package|
  package a_package
end

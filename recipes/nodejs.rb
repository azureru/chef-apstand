#
# Cookbook Name:: appsindo
# Recipe:: nodejs
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

include_recipe "build-essential"
include_recipe "nodejs"
include_recipe "nodejs::npm"
#
# Cookbook Name:: appsindo
# Recipe:: logrotate
#
# Basically just install logrotate on the local machine
#
#
# Copyright 2013, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt::default'

package 'logrotate'
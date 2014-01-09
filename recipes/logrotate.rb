#
# Cookbook Name:: appsindo
# Recipe:: logrotate
#
# Basically just install logrotate on the local machine
#
# Copyright 2013, PT Appsindo Technology
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt::default'

package 'logrotate'
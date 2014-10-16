#
# Cookbook Name:: appsindo
# Recipe:: logrotate
#
# Basically just install logrotate on the local machine
#
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

include_recipe 'apt::default'

package 'logrotate'

# for every logrotate
logrotates = node["logrotate"]
if logrotates.empty? then
    # nothing to do here
else
    # for every logrotate
    logrotates.each do |logrotater|
    end
end
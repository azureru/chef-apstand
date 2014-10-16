#
# Cookbook Name:: appsindo
# Recipe:: upstart
# Description::
#     Install upstart scripts
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

# iterate all entry in `upstart` and create upstart entry

# for every upstart definition
upstarts = node["upstart"]
if upstarts.empty? then
    # nothing to do here
else
    # for every upstart
    upstarts.each do |upstarter|

    end
end
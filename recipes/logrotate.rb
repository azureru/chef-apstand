#
# Cookbook Name:: appsindo
# Recipe:: logrotate
#
# Basically just install logrotate on the local machine
# and create logrotate files
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

include_recipe 'apt::default'

package 'logrotate'

# for every logrotate
logrotates = node["logrotate"]
if logrotates.nil? or logrotates.empty? then
    # nothing to do here
else
    # for every logrotate
    logrotates.each do |logrotater|
        appsindo_logrotate logrotater[:name] do
            path          logrotater[:path]
            create        logrotater[:create]
            frequency     logrotater[:frequency]
            size          logrotater[:size]
            minsize       logrotater[:minsize]
            maxsize       logrotater[:maxsize]
            su            logrotater[:su]
            rotate        logrotater[:rotate]
            olddir        logrotater[:olddir]
            sharedscripts logrotater[:sharedscripts]
            postrotate    logrotater[:postrotate]
            prerotate     logrotater[:prerotate]
            firstaction   logrotater[:firstaction]
            lastaction    logrotater[:lastaction]
            options       logrotater.has_key?("options") ?  logrotater[:options] : nil
            template      logrotater.has_key?("template") ? upstarter[:template] : "upstart_simple.erb"
        end
    end
end
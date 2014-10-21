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
        appsindo_upstart upstarter[:name] do
            name         upstarter[:name]
            description  upstarter[:description]
            author       upstarter[:author]
            version      upstarter[:version]

            user   upstarter[:user]
            group  upstarter[:group]
            umask  upstarter[:umask]
            log_path   upstarter[:log_path]
            pid_path   upstarter[:pid_path]
            app_path   upstarter[:app_path]
            base_path  upstarter[:base_path]

            start_event  upstarter[:start_event]
            stop_event   upstarter[:stop_event]

            pre_start_script   upstarter[:pre_start_script]
            post_start_script  upstarter[:post_start_script]
            pre_stop_script    upstarter[:pre_stop_script]
            post_stop_script   upstarter[:post_stop_script]

            respawn_limit upstarter[:respawn_limit]

            expect      upstarter[:expect]
            exec_method upstarter[:exec_method]

            template     upstarter.has_key?("template") ? "upstart_simple.erb" : upstarter[:template]
        end
    end
end
#
# Cookbook Name:: appsindo
# Resource:: upstart
# Description::
#       LWRP to define Upstart config
#
# Copyright 2013, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
# All rights reserved - Do Not Redistribute
#

actions :create, :delete

attribute :name, :kind_of => String, :name_attribute => true
attribute :cookbook, :kind_of => String, :default => "appsindo"

# metadata - if you don't set this, then it will be my name :P
attribute :description, :kind_of => String, :default => ""
attribute :author, :kind_of => String, :default => "Erwin Saputra <erwin.saputra@at.co.id>"
attribute :version, :kind_of => String, :default => "0.1"

# User and Group
attribute :user, :kind_of => String, :default => "root"
attribute :group, :kind_of => String, :default => "root"
attribute :umask, :kind_of => String, :default => "002"

# execution method - it can be `exec` or `start-stop-daemon` or `script'
attribute :exec_method, :kind_of => String, :default => "start-stop-daemon"
attribute :exec_script, :kind_of => [String, NilClass], :default => nil

# executable expect mode `fork` `daemon` `nil`
attribute :expect, :kind_of => [String, NilClass], :defult => nil

# the path (for executable with param just put `executablename parameter parameter2`)
attribute :app_path, :kind_of => String, :default => "/var/www/service/untitled.js"
attribute :base_path, :kind_of => [String, NilClass], :default => nil
attribute :log_path, :kind_of => [String, NilClass], :default => nil
attribute :pid_path, :kind_of => [String, NilClass], :default => nil

# on start and on stop event
attribute :start_event, :kind_of => String, :default => "runlevel [2345]"
attribute :stop_event, :kind_of => String, :default => "runlevel [!2345]"

# pre-start script
attribute :pre_start_script, :kind_of => [String, NilClass], :default => nil
attribute :post_start_script, :kind_of => [String, NilClass], :default => nil
attribute :pre_stop_script, :kind_of => [String, NilClass], :default => nil
attribute :post_stop_script, :kind_of => [String, NilClass], :default => nil

# respawn limit
attribute :respawn_limit, :kind_of => String, :default => "5 10"

attribute :template, :kind_of => String, :default => "upstart_simple.erb"

def initialize(*args)
  super
  @action = :create
end


#
# Cookbook Name:: appsindo
# Resource:: upstart
# Description::
#       LWRP to define logrotate entry
#
# Copyright 2013, PT Appsindo Technology
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
# All rights reserved - Do Not Redistribute
#

actions :create, :delete

attribute  :frequency, :kind_of => String, :default => "weekly"
attribute  :template , :kind_of => String, :default => "logrotate.erb"
attribute  :cookbook , :kind_of => String, :default => "appsindo"
attribute  :postrotate, :kind_of => [String, NilClass], :default => nil
attribute  :prerotate , :kind_of => [String, NilClass], :default => nil
attribute  :firstaction, :kind_of => [String, NilClass], :default => nil
attribute  :lastaction , :kind_of => [String, NilClass], :default => nil
attribute  :sharedscripts, :kind_of => [TrueClass, FalseClass], :default => false

def initialize(*args)
  super
  @action = :create
end


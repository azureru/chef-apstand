#
# Cookbook Name:: appsindo
# Resource:: upstart
# Description::
#       LWRP to define logrotate entry
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

actions :create, :delete

attribute  :name,      :kind_of => String, :name_attribute => true
attribute  :template , :kind_of => String, :default => "logrotate.erb"
attribute  :cookbook , :kind_of => String, :default => "appsindo"

# logrotate wildcard / path
attribute  :path,      :kind_of => String, :required => true

# possible values: daily, weekly, monthly, yearly
attribute  :frequency,     :kind_of => String, :default => "weekly"

# create
attribute  :create,     :kind_of => [String, NilClass], :default => nil

# size, minsize and maxsize
attribute :size,     :kind_of => [Integer, String, NilClass], :default => nil
attribute :minsize,  :kind_of => [Integer, String, NilClass], :default => nil
attribute :maxsize,  :kind_of => [Integer, String, NilClass], :default => nil

attribute  :olddir,     :kind_of => [String, NilClass], :default => nil

# su
attribute :su, :kind_of => [String, NilClass], :default => nil

# rotate
attribute :rotate,     :kind_of => [Integer, NilClass], :default => nil

# script after log rotated
attribute  :postrotate,    :kind_of => Array, :default => nil

# script before log rotated
attribute  :prerotate ,    :kind_of => Array, :default => nil

# executed once
attribute  :firstaction,   :kind_of => Array, :default => nil


# other custom options
attribute  :options,   :kind_of => Array, :default => nil


# executed once
attribute  :lastaction ,   :kind_of => [String, NilClass], :default => nil

attribute  :sharedscripts, :kind_of => [TrueClass, FalseClass], :default => false

def initialize(*args)
  super
  @action = :create
end


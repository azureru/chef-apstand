#
# Cookbook Name:: appsindo
# Resource:: ngapp
# Description::
#       Define nginx app
#
# Copyright 2013, PT Appsindo Technology
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
# All rights reserved - Do Not Redistribute
#

actions :create, :delete, :disable

attribute :name, :kind_of => String, :name_attribute => true
attribute :cookbook, :kind_of => String, :default => "appsindo"

attribute :https, :kind_of => [TrueClass, FalseClass], :default => false
attribute :force_https, :kind_of => [TrueClass, FalseClass], :default => false

attribute :root_path, :kind_of => String, :default => "/var/www"
attribute :server_name, :kind_of => String, :required => true

# additional includes
attribute :includes, :kind_of => Array, :default => [
    '/etc/nginx/appsindo.d/apps.chrome.conf',
    '/etc/nginx/appsindo.d/apps.expirity.conf',
    '/etc/nginx/appsindo.d/apps.no-transform.conf',
    '/etc/nginx/appsindo.d/apps.opt.conf',
    '/etc/nginx/appsindo.d/apps.security.conf',
    '/etc/nginx/appsindo.d/apps.yii.conf',
]

# app_type of web-app. Can be `php-fpm`, or `proxy`
attribute :app_type, :kind_of => String, :default => "php-fpm"
attribute :pass, :kind_of => String, :default => "unix:/var/run/php5-fpm.sock"

# ssl
attribute :certificate_path, :kind_of => [String, NilClass]
attribute :certificate_key_path, :kind_of => [String, NilClass]

# templating
attribute :template, :kind_of => String, :default => "ngapp.erb"

def initialize(*args)
  super
  @action = :create
end
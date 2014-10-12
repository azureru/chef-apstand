#
# Cookbook Name:: appsindo
# Recipe:: php
# Descriptions::
#
#    Will install PHP and some standard modules
#
# Copyright 2013, PT Appsindo Technology
# @author Erwin Saputra <erwin.saputra@at.co.id>
#
#

node.default['php']['install_method'] = 'package'

package "python-software-properties" do
    action :install
end

apt_repository "ondrej-php-5" do
    uri "http://ppa.launchpad.net/ondrej/php5/ubuntu"
    distribution node["lsb"]["codename"]
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "E5267A6C"
end

execute "Install php55" do
  command "apt-get update -y && apt-get install -y php5"
  action :run
end

include_recipe "php"
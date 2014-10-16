#
# Cookbook Name:: appsindo
# Recipe:: php
# Descriptions::
#    Will install PHP and some standard modules
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

node.default['php']['install_method'] = 'source'

# most of the time, compiling PHP on 512 ram will runout of
# memory - so we setup a temporary swap partition to compile
script 'create swapfile' do
  interpreter 'bash'
  not_if { File.exists?('/var/swapfile') }
  code <<-eof
    dd if=/dev/zero of=/var/swapfile bs=1M count=2048 &&
    chmod 600 /var/swapfile &&
    mkswap /var/swapfile
    swapon /var/swapfile
  eof
end

# install standard issued PHP
include_recipe "php"

# apc will fail in PHP 5.5 use embedded opcode cache instead
# php_pear "apc" do
#  action :install
#  directives(:shm_size => 128, :enable_cli => 1)
# end


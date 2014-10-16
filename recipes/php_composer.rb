#
# Cookbook Name:: appsindo
# Recipe:: php_composer
# Descriptions::
#    Will install Composer globally
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

bash "install Composer Globally" do
  user "root"
  group "root"
  code <<-EOF
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  EOF
end
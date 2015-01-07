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

# install composer
bash "Composer Globally" do
  user  "root"
  group "root"
  code <<-EOF
      curl -sS https://getcomposer.org/installer | php
      mv composer.phar /usr/local/bin/composer
  EOF
end

# install specified global components
globals = node['composer']['globals']
globals.each do |globalModule|
    bash "Composer Global #{globalModule}" do
        user  "root"
        group "root"
        code <<-EOF
            composer global require "#{globalModule}"
        EOF
    end
end

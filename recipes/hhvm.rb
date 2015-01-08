#
# Cookbook Name:: appsindo
# Recipe:: hhvm
# Descriptions::
#
#    Will install HHVM using the recomended method on hhvm.com
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

bash "Install HHVM" do
  code <<-EOF
      wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
      echo deb http://dl.hhvm.com/ubuntu trusty main | sudo tee /etc/apt/sources.list.d/hhvm.list
      sudo apt-get update
      sudo apt-get install hhvm
  EOF
end


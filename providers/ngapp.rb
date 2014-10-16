#
# Cookbook Name:: appsindo
# Provider:: ngapp
#
# Copyright 2013, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

action :delete do
  f1 = file "/etc/nginx/sites-available/#{new_resource.name}" do
    action :delete
  end
  f2 = link "/etc/nginx/sites-enabled/#{new_resource.name}" do
    action :delete
  end
  new_resource.updated_by_last_action(f1.updated_by_last_action?)
end

action :disable do
  f = link "/etc/nginx/sites-enabled/#{new_resource.name}" do
    action :delete
  end
  new_resource.updated_by_last_action(f.updated_by_last_action?)
end

action :create do
  t = template "/etc/nginx/sites-available/#{new_resource.name}" do
    cookbook new_resource.cookbook
    source new_resource.template
    mode "764"
    variables(
       :name     => new_resource.name,
       :cookbook => new_resource.cookbook,
       :https    => new_resource.https,
       :force_https => new_resource.force_https,
       :root_path   => new_resource.root_path,
       :server_name => new_resource.server_name,
       :includes => new_resource.includes,
       :app_type => new_resource.app_type,
       :pass     => new_resource.pass,
       :certificate_path     => new_resource.certificate_path,
       :certificate_key_path => new_resource.certificate_key_path,
    )
    action :create
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end
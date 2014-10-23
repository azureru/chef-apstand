#
# Cookbook Name:: appsindo
# Recipe:: nginx
# Author:: Erwin Saputra <erwin.saputra@at.co.id>
# Description::
#   Install nginx
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

is_pagespeed = node["nginx"]["is_pagespeed"]

if is_pagespeed then
    # download pagespeed
    git "/tmp/ngx_pagespeed" do
        repository  "git://github.com/pagespeed/ngx_pagespeed.git"
        reference   "master"
        action      :sync
    end

    # download psol
    bash "make & install pagespeed SOL for nginx" do
      cwd  "/tmp/ngx_pagespeed"
      code <<-EOF
          wget https://dl.google.com/dl/page-speed/psol/1.9.32.1.tar.gz
          tar -xzvf 1.9.32.1.tar.gz
      EOF
    end

    # tmp for pagespeed
    directory "/var/tmp/pagespeed/" do
      owner   "root"
      group   "root"
      mode    0775
      action  :create
    end

    # pagespeed
    node.default['nginx']['source']['default_configure_flags'].push("--add-module=/tmp/ngx_pagespeed")
end

# prepare tmp for nginx
directory "/var/tmp/nginx/" do
  owner   "root"
  group   "root"
  mode    0755
  action  :create
end
directory "/var/tmp/nginx/client/" do
  owner   "root"
  group   "root"
  mode    0755
  action  :create
end
directory "/var/tmp/nginx/proxy/" do
  owner   "root"
  group   "root"
  mode    0755
  action  :create
end
directory "/var/tmp/nginx/fcgi/" do
  owner   "root"
  group   "root"
  mode    0755
  action  :create
end

include_recipe "nginx"

is_dev = "";
if node.default["environment"] == "development"
  is_dev = ".dev"
end

#---------------------------- Basic Includes
directory "/etc/nginx/appsindo.d" do
  action     :delete
  recursive  true
end

# create /etc/nginx/appsindo.d for default includes
directory "/etc/nginx/appsindo.d" do
  owner    "root"
  group    "root"
  mode     0755
  action   :create
end

%w{
   apps.cachebust.conf
   apps.chrome.conf
   apps.cors-insecure.conf
   apps.expirity.conf
   apps.no-transform.conf
   apps.opt.conf
   apps.pagespeed.conf
   apps.security.conf
   apps.spdy.conf
   apps.ssl.conf
   apps.ssl_stapling.conf
   apps.yii.conf
   apps.yii2.conf
}.each do |file|
    # copy basic `.conf` to include later
    cookbook_file "/etc/nginx/appsindo.d/#{file}" do
      source  "nginx/appsindo.d/#{file}#{is_dev}"
      mode    0644
      owner   "root"
      group   "root"
      action  :create_if_missing
    end
end

#---------------------------- Custom Errors
directory "/etc/nginx/errors.d/" do
  owner   "root"
  group   "root"
  mode    0755
  action  :create
end
%w{404 403 500 503}.each do |file|
    cookbook_file "/etc/nginx/errors.d/#{file}.html" do
      source  "nginx/errors.d/nginx-#{file}.html"
      mode    0644
      owner   "root"
      group   "root"
      action  :create_if_missing
    end
end

#---------------------------- Mime
cookbook_file "/etc/nginx/mime.types" do
  source  "nginx/mime.types#{is_dev}"
  mode    0644
  owner   "root"
  group   "root"
  action  :create
end

#---------------------------- Nginx Core
template "/etc/nginx/nginx.conf" do
  cookbook "appsindo"
  source   "nginx.erb"
  action   :create
  mode     "650"
  variables(
     :pagespeed => is_pagespeed
  )
end

# create `/etc/nginx/sites-available/`
directory "/etc/nginx/sites-available/" do
  owner   "root"
  group   "root"
  mode    0755
  action  :create
end

# create `/etc/nginx/sites-enabled/`
directory "/etc/nginx/sites-enabled/" do
  owner   "root"
  group   "root"
  mode    0755
  action  :create
end

#---------------------------- Upstart Fix
# we do this since the upstart from chef cookbook is broken
# it does not expect `fork` and mess up the process
if node['nginx']['init_style'] == 'upstart' then
    template "/etc/init/nginx.conf" do
      cookbook "appsindo"
      source   "nginx.upstart.erb"
      action   :create
      mode     "650"
      variables(
         :nginx_path => node['nginx']['source']['sbin_path']
         :nginx_pid  => node['nginx']['pid']
      )
    end
end

#---------------------------- Webappr

# SNI limiter
cookbook_file "/etc/nginx/sites-available/00-default" do
  source   "nginx/00-default#{is_dev}"
  mode     0644
  owner    "root"
  group    "root"
  action   :create_if_missing
end

# foreach web-application defined on the `webapp`
webapp = node["webapp"]
if webapp.empty? then
    # the webapp is empty let's define default "Whoaa it's working site"
    # Default Landing
    directory "/var/www/default/logs" do
      owner      "root"
      group      "www-data"
      mode       0775
      recursive  true
      action     :create
    end

    cookbook_file "/var/www/default/index.html" do
      source  "nginx/nginx-default-index.html"
      mode    0655
      owner   "root"
      group   "www-data"
      action  :create_if_missing
    end

    cookbook_file "/var/www/default/info.php" do
      source  "nginx/nginx-default-info.php"
      mode    0655
      owner   "root"
      group   "www-data"
      action  :create_if_missing
    end

    appsindo_ngapp "localhost" do
      name         "localhost"
      https        false
      force_https  false
      root_path    "/var/www/default/"
      server_name  "localhost"
      app_type     "php-fpm"
      pass         "unix:/var/run/php5-fpm.sock"
    end
else
    # for every webapp array
    webapp.each do |app|
        # delete the old config (if any)
        file "/etc/nginx/sites-available/#{app[:server_name]}.conf" do
            action :delete
        end

        log "message" do
            message "webapp #{app[:root_path]} #{app[:server_name]}"
            level :info
        end

        appsindo_ngapp app[:name] do
            name         app[:name]
            https        app[:is_https]
            force_https  app[:is_force_https]
            root_path    app[:root_path]
            server_name  app[:server_name]
            includes     app[:includes]
            app_type     app[:type]
            pass         app[:pass]
            access_log_path      app[:access_log_path]
            error_log_path       app[:error_log_path]
            certificate_path     app[:certificate_path]
            certificate_key_path app[:certificate_key_path]
            template     app.has_key?("template") ? "ngapp.erb" : app[:template]
        end

        # we need `host` alias for inside of the machine
        ruby_block "Host Alias Inside Machine #{app[:server_name]}" do
            block do
                file = Chef::Util::FileEdit.new("/etc/hosts")
                file.insert_line_if_no_match(
                   "127.0.0.1 #{app[:server_name]}",
                   "127.0.0.1 #{app[:server_name]}"
                )
                file.write_file
            end
        end
  end
end

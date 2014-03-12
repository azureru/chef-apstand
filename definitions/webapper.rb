# Webapp Definition Resource For Nginx

# default params
web_params = {
  :enable         => true,

  # listen to these ports?
  :https        => true,

  # if this true - then we will create `http` entry that rewrite to `https`
  :force_https  => false,

  # server-name is equal to name if not specified
  :server_name  => nil,
  :hostname     => nil,

  # root path
  :root_path      => nil,

  # additional includes
  :includes       => [
       '/etc/nginx/appsindo.d/apps.chrome.conf',
       '/etc/nginx/appsindo.d/apps.expirity.conf',
       '/etc/nginx/appsindo.d/apps.no-transform.conf',
       '/etc/nginx/appsindo.d/apps.opt.conf',
       '/etc/nginx/appsindo.d/apps.security.conf',
       '/etc/nginx/appsindo.d/apps.yii.conf',
  ],

  # app_type of web-app. Can be `php-fpm`, or `proxy`
  :app_type       => 'php-fpm',
  :pass           => 'http://localhost:9000/',

  # ssl
  :certificate_path      => nil,
  :certificate_key_path  => nil,

  # templating
  :template => 'webapp.erb',
  :cookbook => 'appsindo',
  :template_mode  => '0655',
  :template_owner => 'root',
  :template_group => 'root'
}

define(:webapper, web_params) do
    # name is mandatory!
    if params[:name].nil?
        Chef::Application.fatal! "Name is required for `webapper`"
    end

    # if force-https specified then https must be true
    if params[:force_https]
        params[:https] = true
    end

    # if not speficied then server name=name
    if params[:server_name].nil?
        params[:server_name] = params[:name]
    end

    # if hostname not specified then use server_name
    if params[:hostname].nil?
        params[:hostname] = params[:server_name]
    end

    # root
    if params[:root_path].nil?
       Chef::Application.fatal! "Root Path is required for `webapper`"
    else
        # append `/` on path
        params[:root_path] << '/' unless params[:root_path].end_with?('/')
    end

    # we need certificate for enabled https
    if params[:https]
        if params[:certificate_path].nil?
            Chef::Application.fatal! "Certificate is required if https enabled"
        end
        if params[:certificate_key_path].nil?
            Chef::Application.fatal! "Certificate Key is required if https enabled"
        end
    end

    if params[:enable]
        # create `site-name` based on parameters
        template "/etc/nginx/sites-available/#{params[:name]}" do
          source   params[:template]
          cookbook params[:cookbook]
          mode     params[:template_mode]
          owner    params[:template_owner]
          group    params[:template_group]
          backup   false
          variables(
             :https          => params[:https],
             :force_https    => params[:force_https],
             :certificate_path      => params[:certificate_path],
             :certificate_key_path  => params[:certificate_key_path],

             :app_type           => params[:app_type],

             :name           => params[:name],
             :server_name    => params[:server_name],
             :hostname       => params[:hostname],

             :root_path      => params[:root_path],
             :includes       => params[:includes],
             :pass           => params[:pass]
          )
        end
        # create symbolic link of the file
        link "/etc/nginx/sites-enabled/#{params[:name]}" do
          to "/etc/nginx/sites-available/#{params[:name]}"
          owner    params[:template_owner]
          group    params[:template_group]
        end
    else
        file "/etc/nginx/sites-available/#{params[:name]}" do
            action :delete
        end
        file "/etc/nginx/sites-enabled/#{params[:name]}" do
            force_unlink true
            action :delete
        end
    end
end
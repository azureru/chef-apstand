#
# Upstart Definition for Simple Daemon / Process
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

# default params
node_params = {
  :enable         => true,

  # metadata - if you don't set this param - then it will be my name *smirk*
  :description    => '',
  :author         => 'Erwin Saputra <erwin.saputra@at.co.id>',
  :version        => '0.1',

  # UID and GID
  :user           => 'root',
  :group          => 'root',
  :umask          => '0002',

  # execution method - it can be `exec` or `start-stop-daemon` or `script'
  :exec_method    => 'start-stop-daemon',
  :exec_script    => nil,

  # executable expect mode `fork` `daemon` `nil`
  :expect         => nil,

  # the path (for executable with param just put `executablename parameter parameter2`)
  :app_path       => '/var/www/service/untitled.js',
  :base_path      => nil,

  # on start and on stop
  :start_event    => 'runlevel [2345]',
  :stop_event     => 'runlevel [!2345]',

  # pre-start script
  :pre_start_script      => nil,
  :post_start_script     => nil,
  :pre_stop_script       => nil,
  :post_stop_script      => nil,

  # respawn limit
  :respawn_limit   => '5 10',

  :template => 'upstart_simple.erb',
  :cookbook => 'chef-apstand',
  :template_mode  => '0655',
  :template_owner => 'root',
  :template_group => 'root'
}

define(:upstarter, node_params) do
    # name is mandatory!
    if params[:name].nil?
        Chef::Application.fatal! "Name is required for `upstarter`"
    end

    # base path by default use base of :app_path
    if params[:base_path].nil?
        params[:base_path] = File.expand_path(File.dirname(params[:app_path]))
    end

    # if log path no specified use `name.log`
    if params[:log_path].nil?
        params[:log_path] = '/var/log/' + params[:name] + '.log'
    end

    # pid similar to log path use `name.pid`
    if params[:pid_path].nil?
        params[:pid_path] = '/var/pid/' + params[:name] + '.pid'
    end

    # execution mode depends on the `:exec_method` value
    # nodejs based use `start-stop-daemon`
    # Binary use `exec`
    # And there's `script` for those who brave :P
    execution = ""
    case params[:exec_method]
        when 'exec'
          execution = "exec $APP_PATH"
        when 'script'
          execution = "script" + "\n" + params[:exec_script] + "\n" + "end script"
        when 'start-stop-daemon'
          execution = "exec start-stop-daemon --start --chuid $USER:$GROUP --chdir $BASE_PATH --make-pidfile --pidfile $PID --exec $APP_PATH >> $LOG 2>&1"
    end

    if params[:enable]
        # create /etc/init/ entry based on existing parameters
        template "/etc/init/#{params[:name]}.conf" do
          source   params[:template]
          cookbook params[:cookbook]
          mode     params[:template_mode]
          owner    params[:template_owner]
          group    params[:template_group]
          backup   false
          variables(
            :description      => params[:description],
            :author           => params[:author],
            :name             => params[:name],
            :version          => params[:version],

            :user             => params[:user],
            :group            => params[:group],
            :umask            => params[:umask],

            :exec_method    => params[:exec_method],
            :expect  => params[:expect],
            :execution => execution,

            :app_path         => params[:app_path],
            :base_path        => params[:base_path],

            :log_path       => params[:log_path],
            :pid_path       => params[:pid_path],

            :start_event    => params[:start_event],
            :stop_event     => params[:stop_event],

            :pre_start_script  => params[:pre_start_script],
            :post_start_script => params[:post_start_script],
            :pre_stop_script   => params[:pre_stop_script],
            :post_stop_script  => params[:pre_stop_script],

            :respawn_limit     => params[:respawn_limit]
          )
        end
    else
        # remove it
        file "/etc/logrotate.d/#{params[:name]}" do
          action :delete
        end
    end
end
#
# Cookbook Name:: appsindo
# Provider:: upstart
#
# Copyright 2014, PT Appsindo Technology as BSD-style found in the LICENSE file
#
# @author Erwin Saputra <erwin.saputra@at.co.id>
#

action :delete do
  f1 = file "/etc/init/#{new_resource.name}" do
    action :delete
  end
  new_resource.updated_by_last_action(f1.updated_by_last_action?)
end

action :create do
    # base path by default use base of :app_path
    if new_resource.base_path.nil?
        new_resource.base_path = File.expand_path(File.dirname(new_resource.app_path))
    end

    # if log path no specified use `name.log`
    if new_resource.log_path.nil?
        new_resource.log_path = '/var/log/' + new_resource.name + '.log'
    end

    # pid similar to log path use `name.pid`
    if new_resource.pid_path.nil?
        new_resource.pid_path = '/var/pid/' + new_resource.name + '.pid'
    end

    # execution mode depends on the `:exec_method` value
    # PHP or nodejs based use `start-stop-daemon`
    # Daemon Binary use `exec`
    # And there's `script` for those who brave :P
    execution = ""
    case new_resource.exec_method
        when 'exec'
          execution = "exec $APP_PATH"
        when 'script'
          execution = "script" + "\n" + new_resource.exec_script + "\n" + "end script"
        when 'start-stop-daemon'
          execution = "exec start-stop-daemon --start --chuid $USER:$GROUP --chdir $BASE_PATH --make-pidfile --pidfile $PID --exec $APP_PATH >> $LOG 2>&1"
    end

    # create /etc/init/ entry based on existing parameters
    t = template "/etc/init/#{new_resource.name}.conf" do
          action :create
          source   new_resource.template
          cookbook new_resource.cookbook
          mode     "764"
          owner    "root"
          group    "root"
          backup   false
          variables(
            :description      => new_resource.description,
            :author           => new_resource.author,
            :name             => new_resource.name,
            :version          => new_resource.version,

            :user             => new_resource.user,
            :group            => new_resource.group,
            :umask            => new_resource.umask,

            :exec_method    => new_resource.exec_method,
            :expect  => new_resource.expect,
            :execution => execution,

            :app_path         => new_resource.app_path,
            :base_path        => new_resource.base_path,

            :log_path       => new_resource.log_path,
            :pid_path       => new_resource.pid_path,

            :start_event    => new_resource.start_event,
            :stop_event     => new_resource.stop_event,

            :pre_start_script  => new_resource.pre_start_script,
            :post_start_script => new_resource.post_start_script,
            :pre_stop_script   => new_resource.pre_stop_script,
            :post_stop_script  => new_resource.pre_stop_script,

            :respawn_limit     => new_resource.respawn_limit
          )
    end
    new_resource.updated_by_last_action(t.updated_by_last_action?)
end




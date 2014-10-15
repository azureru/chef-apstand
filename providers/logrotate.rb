#
# Cookbook Name:: appsindo
# Provider:: logrotate
#

action :delete do
  f1 = file "/etc/logrotate.d/#{new_resource.name}" do
    action :delete
  end
  new_resource.updated_by_last_action(f1.updated_by_last_action?)
end

action :create do
    include_recipe 'appsindo::logrotate'

    # Check for params - fill it with defaults
    acceptable_options = %w(missingok compress delaycompress dateext dateyesterday copytruncate notifempty delaycompress ifempty mailfirst nocompress nocopy nocopytruncate nocreate nodelaycompress nomail nomissingok noolddir nosharedscripts notifempty sharedscripts)
    options_tmp = new_resource.options ||= %w(missingok compress delaycompress copytruncate notifempty)
    options = options_tmp.respond_to?(:each) ? options_tmp : options_tmp.split

    # check for invalid parameters
    invalid_options = options - acceptable_options
    unless invalid_options.empty?
      Chef::Application.fatal! "The passed value(s) [#{invalid_options.join(',')} are not valid"
    end

    # create logrotate.d entry based on existing parameters
    t = template "/etc/logrotate.d/#{new_resource.name}" do
      source   new_resource.template
      cookbook new_resource.cookbook
      mode     "764"
      owner    "root"
      group    "root"
      backup   false
      variables(
        :path          => Array(new_resource.path).map { |path| path.to_s.inspect }.join(' '),
        :create        => new_resource.create,
        :frequency     => new_resource.frequency,
        :size          => new_resource.size,
        :minsize       => new_resource.minsize,
        :maxsize       => new_resource.maxsize,
        :su            => new_resource.su,
        :rotate        => new_resource.rotate,
        :olddir        => new_resource.olddir,
        :sharedscripts => new_resource.sharedscripts,
        :postrotate    => Array(new_resource.postrotate).join("\n"),
        :prerotate     => Array(new_resource.prerotate).join("\n"),
        :firstaction   => Array(new_resource.firstaction).join("\n"),
        :lastaction    => Array(new_resource.lastaction).join("\n"),
        :options       => options
      )
    end
    new_resource.updated_by_last_action(t.updated_by_last_action?)
end






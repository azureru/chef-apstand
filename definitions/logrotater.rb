#
# Log Rotate Definition Resource
#
# Copyright 2009, Scott M. Likens (Apache 2.0 License)
#

# default params
log_rotate_params = {
  :enable         => true,
  :frequency      => 'weekly',
  :template       => 'logrotate.erb',
  :cookbook       => 'appsindo',
  :template_mode  => '0440',
  :template_owner => 'root',
  :template_group => 'root',
  :postrotate     => nil,
  :prerotate      => nil,
  :firstaction    => nil,
  :lastaction     => nil,
  :sharedscripts  => false
}

define(:logrotater, log_rotate_params) do
  include_recipe 'appsindo::logrotate'

  # Check for params - fill it with defaults
  acceptable_options = %w(missingok compress delaycompress dateext dateyesterday copytruncate notifempty delaycompress ifempty mailfirst nocompress nocopy nocopytruncate nocreate nodelaycompress nomail nomissingok noolddir nosharedscripts notifempty sharedscripts)
  options_tmp = params[:options] ||= %w(missingok compress delaycompress copytruncate notifempty)
  options = options_tmp.respond_to?(:each) ? options_tmp : options_tmp.split

  if params[:enable]
    # check for invalid parameters
    invalid_options = options - acceptable_options
    unless invalid_options.empty?
      Chef::Application.fatal! "The passed value(s) [#{invalid_options.join(',')}] are not valid"
    end

    # create logrotate.d entry based on existing parameters
    template "/etc/logrotate.d/#{params[:name]}" do
      source   params[:template]
      cookbook params[:cookbook]
      mode     params[:template_mode]
      owner    params[:template_owner]
      group    params[:template_group]
      backup   false
      variables(
        :path          => Array(params[:path]).map { |path| path.to_s.inspect }.join(' '),
        :create        => params[:create],
        :frequency     => params[:frequency],
        :size          => params[:size],
        :minsize       => params[:minsize],
        :maxsize       => params[:maxsize],
        :su            => params[:su],
        :rotate        => params[:rotate],
        :olddir        => params[:olddir],
        :sharedscripts => params[:sharedscripts],
        :postrotate    => Array(params[:postrotate]).join("\n"),
        :prerotate     => Array(params[:prerotate]).join("\n"),
        :firstaction   => Array(params[:firstaction]).join("\n"),
        :lastaction    => Array(params[:lastaction]).join("\n"),
        :options       => options
      )
    end
  else
    file "/etc/logrotate.d/#{params[:name]}" do
      action :delete
    end
  end
end
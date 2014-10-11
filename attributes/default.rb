# Default Attributes For Appsindo Cookbook

default['phpredis']['revision'] = 'master'

default['ntp']['servers'] = ['0.pool.ntp.org', '1.pool.ntp.org']

default['mysql']['service_name'] = 'default'
default['mysql']['server_root_password'] = 'ilikerandompasswords'
default['mysql']['server_debian_password'] = 'postinstallscriptsarestupid'
default['mysql']['data_dir'] = '/var/lib/mysql'
default['mysql']['port'] = '3306'

default['mysql']['allow_remote_root'] = false
default['mysql']['remove_anonymous_users'] = true
default['mysql']['root_network_acl'] = nil
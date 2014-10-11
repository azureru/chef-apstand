name             'chef-apstand'
maintainer       'Appsindo Technology'
maintainer_email 'erwin.saputra@at.co.id'
license          'All rights reserved'
description      'Installs/Configures Server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "chef-apstand", "Default"
recipe "chef-apstand::nginx", "Customize Nginx"
recipe "chef-apstand::logrotate", "Helper for logrotater"

depends 'ohai', '~> 1.0'
depends 'build-essential'
depends 'xml'
depends 'apt','~> 2.2'
depends 'php','~> 1.3'
depends 'nginx'
depends 'nodejs'
depends 'mysql'
depends 'redisio', '>= 1.7.1'
depends 'npm'
depends 'ntp', '~> 1.6.5'
depends 'git'
depends 'cron'

supports 'debian'
supports 'ubuntu'

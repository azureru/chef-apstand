name             'appsindo'
maintainer       'Appsindo Technology'
maintainer_email 'erwin.saputra@at.co.id'
license          'All rights reserved'
description      'Installs/Configures appsindo'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "appsindo", "Default"
recipe "appsindo::nginx", "Customize Nginx"
recipe "appsindo::logrotate", "Helper for logrotater"

depends 'apt','~> 2.2'
depends 'php','~> 1.3'

supports 'debian'
supports 'ubuntu'

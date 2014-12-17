name             'appsindo'
maintainer       'Appsindo Technology'
maintainer_email 'erwin.saputra@at.co.id'
license          'All rights reserved'
description      'Installs/Configures Server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.0'

recipe "appsindo", "Default"

depends 'ohai'
depends 'build-essential'
depends 'xml'
depends 'apt'
depends 'php'
depends 'nginx'
depends 'nodejs'
depends 'mysql', '~>5.6.1'
depends 'redisio'
depends 'ntp'
depends 'git'
depends 'cron'

supports 'debian'
supports 'ubuntu'
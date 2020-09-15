class update {
  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }
}
class curl {
  package { 'curl':
      ensure    => installed,
      require => Exec['apt-update'],
  }
}
class nodejs {
  exec { 'node':
    command => 'curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -',
            provider => 'shell'
  }
  package { 'nodejs':
    ensure    => installed,
              require => Exec['apt-update'],
  }
}

node 'appserver.lan' {
  include update
  include curl
  include nodejs
}

node 'dbserver.lan' {
    include update
    package { 'mysql-server':
      ensure    => installed,
      require => Exec['apt-update'],
    }
    exec { 'set-mysql-password':
      path => ['/bin', '/usr/bin'],
      command => "mysqladmin -u root password root",
      require => Service['mysql'],
    }
    service { "mysql":
      ensure => "running",
             enable => "true",
             require => Package["mysql-server"],
    }
}

node 'web.lan'  {
  include update
  package { 'nginx':
    ensure    => installed,
    require => Exec['apt-update'],
  }
  service { "nginx":
    ensure => "running",
           enable => "true",
           require => Package["nginx"],
  }
}

node default {
  include update
}

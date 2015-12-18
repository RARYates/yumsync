class yumsync::masterfiles {

  package {'epel-release':
    ensure => present,
  }

  package {'inotify-tools':
    ensure  => present,
    require => Package['epel-release'],
  }

  file {'/usr/bin/repowatch':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
    source => 'puppet:///modules/yumsync/repowatch',
  }

}

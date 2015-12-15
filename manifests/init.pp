# == Class: yumsync
#
# yumsync sets a cronjob (default every minute) that reposync's with an upstream repository and runs a new createrepo
#
# === Parameters
#
# [*localrepo*]
# determines the directory name the repository will be created in. Defaults to the name of the resource.
# [*remoterepo*]
# The repoid (name) of the repository in /etc/yum.repos.d that is to be synced. Defaults to the name of the resource
# [*rootdir*]
# The directory the local repository should be placed in. A folder named after the localrepo variable will be placed here. This will default to /var/www/yum.
# [*new_only*]
# If set to true, will only download the most recent version of every package. This defaults to false.
# [*manage_yumrepo*]
# If set to true, will set up the yumrepo in /etc/yum.repos.d. If this command is used, remote_url must be set.
#[*frequency*]
# Sets the minute tab of the cron running repoupdate. Defaults to *, which makes this run every minute.
#[*remote_url*]
# Sets the URL of the repository that will be synced. Only used it manage_yumrepo is set to true.
#[*remote_repo_desc*]
# Optional setting to set the description of a managed repo
# === Examples
#
# This example would create a /var/www/yum/CentOS-Base repository syncing from the CentOS-Base repo in /etc/yum.repos.d
#
# yumsync{'CentOS-Base':}
#
# This example would create an nginx-dev repository at /opt/yum/nginx-dev, set up the nginx repo at /etc/yum.repos.d,
# and download only the newest rpms from nginx into the nnginx-dev repository.
#
#  yumsync{'nginx-dev':
#    manage_yumrepo => true,
#    remote_url => 'http://nginx.org/packages/centos/$releasever/$basearch/',
#    remoterepo => 'nginx',
#    rootdir    => '/opt/yum',
#    new_only   => true,
#  }
#
# === Authors
#
# Ryan Russell-Yates (ryan.russell-yates@onyxpoint.com)
#
define yumsync (
  $localrepo = $name,
  $remoterepo = $name,
  $rootdir = '/var/www/yum',
  $new_only = false,
  $manage_yumrepo = false,
  $frequency = '*',
  $remote_url = '',
  $remote_repo_desc = 'This repository is managed by puppet yumsync',
) {

include 'yumsync::packages'

  exec {"Create ${rootdir}/${localrepo}":
    command => "/bin/mkdir -p ${rootdir}/${localrepo}",
    creates => "${rootdir}/${localrepo}",
  }

  if $new_only == true {
    $syncflags =  '-n'
  }
  if $remoterepo == $localrepo {
    cron {"${remoterepo}->${localrepo}-reposync":
      ensure  => present,
      command => "/usr/bin/yum makecache; /usr/bin/reposync --repoid=${remoterepo} --download_path=${rootdir} ${syncflags}; createrepo --update ${rootdir}/${localrepo}",
      minute  => $frequency,
      require => [Package['createrepo','yum-utils'],Exec["Create ${rootdir}/${localrepo}"]]
    }
  }
  else {
    cron {"${remoterepo}->${localrepo}-reposync":
      ensure  => present,
      command => "/usr/bin/yum makecache; /usr/bin/reposync --repoid=${remoterepo} --download_path=${rootdir}/${localrepo} ${syncflags}; createrepo --update ${rootdir}/${localrepo}",
      minute  => $frequency,
      require => [Package['createrepo','yum-utils'],Exec["Create ${rootdir}/${localrepo}"]]
    }
  }

  if $manage_yumrepo == true {
    if $remote_url == '' {
      fail('yumsync::remote_url must be set if yumsync::manage_yumrepo is set to true')
    }

    yumrepo{$remoterepo:
      ensure  => present,
      baseurl => $remote_url,
      descr   => $remote_repo_desc
    }
  }

}

#Creates the directory structure of the live repo, while updating the repos every 2 minutes.
# == Class: yumsync::master
#
# yumsync::master sets a file named "repowatch" to /usr/bin and runs it as a daemon on a directory.
# The directory will automatically run a createrepo --update whenever a file ending in ".rpm" is added,
# removed or moved in the directory.
#
# NOTE: Puppet will only place repowatch on a directory once, but puppet will not shut that service off. To shut off all repowatches, enter pkill repowatch
#
# === Parameters
#
#[*directory*]
# Sets the directory to be continually watched for RPM changes and updated with createrepo. Defaults to name variable
#
# === Examples
#
# This example places a repowatch on /var/www/yum/myapp, which will automatically update when any file ending in .rpm is added, deleted or modified
#
# yumsync::master{'/var/www/yum/myapp':}
#
# === Authors
#
# Ryan Russell-Yates (ryan.russell-yates@onyxpoint.com)
#

define yumsync::master (
  $directory = $name,
) {

  include 'yumsync::masterfiles'

  exec {"Create ${directory}":
    command  => "/bin/mkdir -p ${directory}",
    creates  => $directory,
    notify   => Exec["Initial ${directory} repodata"]
  }

  exec {"Initial ${directory} repodata":
    command     => "/usr/bin/createrepo ${directory}",
    refreshonly => true,
  }

  exec {"Watch ${directory}":
    command => "/usr/bin/repowatch ${directory} & disown -h %1",
    unless  => "/bin/ps -ef | grep 'repowatch ${directory}' | grep -v grep",
    require => [Exec["Create ${directory}"],File['/usr/bin/repowatch'],Package['inotify-tools']],
  }

}

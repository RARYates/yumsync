# yumsync

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with yumsync](#setup)
    * [What yumsync affects](#what-yumsync-affects)
    * [Beginning with yumsync](#beginning-with-yumsync)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

yumsync automatically syncs a local repository to an upstream remote repository.

yumsync::master automatically updates a repository as RPMs are added, removed or modified

## Module Description

yumsync sets a cronjob (default every minute) that reposync's with an upstream repository and runs a new createrepo

yumsync::master sets a file named "repowatch" to /usr/bin and runs it as a daemon on a directory.
The directory will automatically run a createrepo --update whenever a file ending in ".rpm" is added,
removed or moved in the directory.

## Setup

### What yumsync affects

yumsync installs yum-utils and createrepo. It will set a cronjob and optionally can place a repository in yum.repos.d

yumsync::master installs inotifywait and a custom program, /usr/bin/repowatch which is utilized for monitoring the directory for updates. Puppet will daemonize this utility in the background.

### Beginning with yumsync

This example would create a /var/www/yum/CentOS-Base repository syncing from the CentOS-Base repo in /etc/yum.repos.d

yumsync{'CentOS-Base':}

This example places a repowatch on /var/www/yum/myapp, which will automatically update when any file ending in .rpm is added, deleted or modified

yumsync::master{'/var/www/yum/myapp':}

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

[*localrepo*]
determines the directory name the repository will be created in. Defaults to the name of the resource.
[*remoterepo*]
The repoid (name) of the repository in /etc/yum.repos.d that is to be synced. Defaults to the name of the resource
[*rootdir*]
The directory the local repository should be placed in. A folder named after the localrepo variable will be placed here. This will default to /var/www/yum.
[*new_only*]
If set to true, will only download the most recent version of every package. This defaults to false.
[*manage_yumrepo*]
If set to true, will set up the yumrepo in /etc/yum.repos.d. If this command is used, remote_url must be set.
[*frequency*]
Sets the minute tab of the cron running repoupdate. Defaults to *, which makes this run every minute.
[*remote_url*]
Sets the URL of the repository that will be synced. Only used it manage_yumrepo is set to true.
[*remote_repo_desc*]
Optional setting to set the description of a managed repo

This example would create an nginx-dev repository at /opt/yum/nginx-dev, set up the nginx repo at /etc/yum.repos.d, and download only the newest rpms from nginx into the nnginx-dev repository.

yumsync{'nginx-dev':
  manage_yumrepo => true,
  remote_url => 'http://nginx.org/packages/centos/$releasever/$basearch/',
  remoterepo => 'nginx',
  rootdir    => '/opt/yum',
  new_only   => true,
}

## Limitations

yumsync and yumsync::master were only tested on CentOS 6.7, but will likely work with minimal modifications on Centos 7 as well.

# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
yumsync{'puppet':
  remote_url              => 'https://yum.puppetlabs.com/el/6/products/x86_64/',
  rootdir                 => '/var/test',
  new_only                => true,
  manage_yumrepo          => true,
  remote_repo_desc        => 'Puppetlabs'
}

yumsync{'nginx':
  remote_url     => 'http://nginx.org/packages/centos/$releasever/$basearch/',
  rootdir        => '/var/test',
  new_only       => true,
  manage_yumrepo => true,
}

yumsync{'slave':
  remoterepo     => 'master',
  rootdir        => '/var/test',
  manage_yumrepo => true,
  remote_url     => 'http://localhost/master',
  require        => Yumsync::Master['/var/test/master'],
}

yumsync::master{'/var/test/master':}

class {'apache': default_vhost => false }

apache::vhost {'localhost':
  port    => '80',
  docroot => '/var/test',
}

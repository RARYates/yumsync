require 'spec_helper'
describe 'yumsync::master' do

  context 'Create a yumsync master' do
    let(:title) { '/var/www/yum/master' }

    it {
      is_expected.to contain_class('yumsync::masterfiles')
      is_expected.to contain_exec('Create /var/www/yum/master').with({
        'command' => '/bin/mkdir -p /var/www/yum/master',
        'creates' => '/var/www/yum/master',
        'notify'  => 'Exec[Initial /var/www/yum/master repodata]'
      })
      is_expected.to contain_exec('Initial /var/www/yum/master repodata').with({
        'command'     => '/usr/bin/createrepo /var/www/yum/master',
        'refreshonly' => true,
      })
      is_expected.to contain_exec('Watch /var/www/yum/master').with({
        'command' => '/usr/bin/repowatch /var/www/yum/master & disown -h %1',
        'unless'  => '/bin/ps -ef | grep \'repowatch /var/www/yum/master\' | grep -v grep',
      })
    }
  end
  
end

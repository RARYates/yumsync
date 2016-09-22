require 'spec_helper'
describe 'yumsync::masterfiles' do

  context 'With mastefiles included' do
    it {
      is_expected.to contain_package('epel-release')
      is_expected.to contain_package('inotify-tools').with({
        'require' => 'Package[epel-release]'
      })
      is_expected.to contain_file('/usr/bin/repowatch').with({
        'source' => 'puppet:///modules/yumsync/repowatch',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0700',
      })
    }
  end

end

require 'spec_helper_acceptance'

test_name 'master'

describe 'master' do

  hosts.each do |host|

    it 'should apply the defined type' do
      apply_manifest(%{
        yumsync::master{'/var/www/yum/master':}
      }, :catch_failures => true)
    end

    it 'should update after pulling an RPM from an outside source' do
#        grab_rpm = "bash -c 'wget ftp://195.220.108.108/linux/mageia/distrib/cauldron/armv5tl/media/core/release/openssh-7.3p1-1.mga6.armv5tl.rpm -P /var/www/yum/master'"
#        check_repodata = "bash -c 'sleep 30;test -d /var/www/yum/master/repodata'"
#        on(host, grab_rpm) { assert_equal(0, exit_code) }
#        on(host, check_repodata) { assert_equal(0, exit_code) }
      on host, "wget ftp://195.220.108.108/linux/mageia/distrib/cauldron/armv5tl/media/core/release/openssh-7.3p1-1.mga6.armv5tl.rpm -P /var/www/yum/master"
      on host, "bash -c 'sleep 30;test -d /var/www/yum/master/repodata'"
    end
  end

#        check_temp = "bash -c 'cat /tmp/test'"
#        on(host, create_temp) { assert_equal(0, exit_code) }
end

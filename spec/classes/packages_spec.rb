require 'spec_helper'
describe 'yumsync::packages' do

  it {
    is_expected.to contain_package('createrepo')
    is_expected.to contain_package('yum-utils')
  }

end

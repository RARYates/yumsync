require 'spec_helper'
describe 'yumsync' do

  context 'with defaults for all parameters' do
    let(:title) { 'test' }
    it { 
      is_expected.to contain_class('yumsync::packages')
      is_expected.to contain_exec('Create /var/www/yum/test')
      is_expected.to contain_cron('test->test-reposync')
    }
  end

  context 'with manage_yumrepo to true' do
    let(:title) { 'test' }
    let(:params) { {
      :manage_yumrepo => true,
      :remote_url     => true
    } }

    it { 
      is_expected.to contain_yumrepo('test')
    }
  end


end

require 'spec_helper'
describe 'yumsync' do

  context 'with defaults for all parameters' do
    it { should contain_class('yumsync') }
  end
end

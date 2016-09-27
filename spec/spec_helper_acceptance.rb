require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'pry'

run_puppet_install_helper

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      #install_dev_puppet_module_on(host, :source => proj_root, :module_name => 'yumsync', :target_module_path => '/etc/puppet/modules')
      copy_module_to(host, :source => proj_root, :module_name => 'yumsync')
    end
  end
end

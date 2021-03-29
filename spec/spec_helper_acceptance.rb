require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

hosts.each do |host|
  run_puppet_install_helper_on(host)

  # Install pry-byebug dependencies
  install_package(host, 'make')
  install_package(host, 'gcc')
  install_package(host, 'git')

  # Required third-party modules
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  modules_fixtures = YAML.load_file(module_root + '/.fixtures.yml')
  modules = modules_fixtures['fixtures']['repositories']

  hosts.each do |host|
    puts 'Install fixtures'
    modules.each do |mod_name, mod_info|
      url = mod_info['repo']
      ref = mod_info['ref']
      dir = '/etc/puppetlabs/code/environments/production/modules/' + mod_name

      puts format(' - Fetch %s with %s from %s', mod_name, ref, url)
      git_clone = format('git clone %s %s', url, dir)
      git_checkout = format('cd %s && git checkout %s', dir, ref)

      on host, git_clone
      on host, git_checkout
    end
  end
end

install_module_on(hosts)
install_module_dependencies_on(hosts)

require 'spec_helper_acceptance'

describe 'calico install' do
  before(:all) do
    manifest = <<-EOS
    include docker
    include etcd
    EOS
    apply_manifest(manifest, :catch_failures => true)
  end

  let(:manifest_calico) do
    <<-EOS
    class { '::calico':
      # Calico CNI plugin binary patched for Nomad support
      cni_binary => 'https://github.com/acbox/cni-plugin/releases/download/v3.18.1-acbox-0/calico-amd64',
    }
    EOS
  end

  let(:manifest_node) do
    <<-EOS
    calico_node { 'vagrant':
    }
    EOS
  end

  let(:manifest_ippool) do
    <<-EOS
    calico_ip_pool { 'myippool':
      cidr => '10.0.2.0/24', # https://www.virtualbox.org/manual/UserManual.html#nat-address-config
    }
    EOS
  end

  let(:manifest_host_endpoint) do
    <<-EOS
    calico_host_endpoint { 'vagrant':
      expectedips => ['10.0.2.15'],
      node        => 'vagrant',
      labels      => { 'role' => 'host' }
    }
    EOS
  end

  let(:manifest_global_network_policy) do
    <<-EOS
    calico_global_network_policy { 'host-egress-all':
      selector => 'role == "host"',
      order    => 0,
      types    => [ 'Egress' ],
      ingress  => [],
      egress   => [
        { action => 'Allow', protocol => 'UDP', destination => {} },
        { action => 'Allow', protocol => 'TCP', destination => {} },
      ],
    }
    EOS
  end

  let(:manifest_global_network_policy_string_port) do
    <<-EOS
    calico_global_network_policy { 'test-ports':
      selector => 'role == "host"',
      order    => 0,
      types    => [ 'Ingress' ],
      egress   => [],
      ingress  => [
        { action => 'Allow', protocol => 'UDP', destination => { ports => [ '3000' ] } },
      ],
    }
    EOS
  end

  let(:manifest_global_network_policy_integer_port) do
    <<-EOS
    calico_global_network_policy { 'test-ports':
      selector => 'role == "host"',
      order    => 0,
      types    => [ 'Ingress' ],
      egress   => [],
      ingress  => [
        { action => 'Allow', protocol => 'UDP', destination => { ports => [ 3000 ] } },
      ],
    }
    EOS
  end

  it 'should apply without errors' do
    apply_manifest(manifest_calico, :catch_failures => true)
  end

  it 'should apply a second time without changes' do
    @result = apply_manifest(manifest_calico, :catch_failures => true)
    expect(@result.exit_code).to be_zero
  end

  it 'should apply without errors' do
    apply_manifest(manifest_node, :catch_failures => true)
  end

  it 'should apply a second time without changes' do
    @result = apply_manifest(manifest_node, :catch_failures => true)
    expect(@result.exit_code).to be_zero
  end

  it 'should apply without errors' do
    apply_manifest(manifest_ippool, :catch_failures => true)
  end

  it 'should apply a second time without changes' do
    @result = apply_manifest(manifest_ippool, :catch_failures => true)
    expect(@result.exit_code).to be_zero
  end

  it 'should apply without errors' do
    apply_manifest(manifest_host_endpoint, :catch_failures => true)
  end

  it 'should apply a second time without changes' do
    @result = apply_manifest(manifest_host_endpoint, :catch_failures => true)
    expect(@result.exit_code).to be_zero
  end

  it 'should apply without errors' do
    @result = apply_manifest(manifest_global_network_policy, :catch_failures => true)
  end

  it 'should apply a second time without changes' do
    @result = apply_manifest(manifest_global_network_policy, :catch_failures => true)
    expect(@result.exit_code).to be_zero
  end

  # test canonicalize() 1/2
  it 'should accept string port' do
    @result = apply_manifest(manifest_global_network_policy_string_port, :catch_failures => true)
  end

  # test canonicalize() 2/2
  it 'should accept integer without changes' do
    @result = apply_manifest(manifest_global_network_policy, :catch_failures => true)
    expect(@result.exit_code).to be_zero
  end
end

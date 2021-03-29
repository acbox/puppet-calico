require 'spec_helper_acceptance'

describe 'calico install' do
  let(:manifest) {
    <<-EOS
    class { '::calico':
      # Calico CNI plugin binary patched for Nomad support
      cni_binary => 'https://github.com/acbox/cni-plugin/releases/download/v3.18.1-acbox-0/calico-amd64',
    }
    EOS
  }
  it 'should apply without errors' do
    apply_manifest(manifest, :catch_failures => true)
  end

  it 'should apply a second time without changes' do
    @result = apply_manifest(manifest)
    expect(@result.exit_code).to be_zero
  end
end

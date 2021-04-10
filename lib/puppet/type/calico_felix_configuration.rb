# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'calico_felix_configuration',
  docs: <<-EOS,
@summary a calico_felix_configuration type
@example
calico_felix_configuration { 'myconfig':
  default_endpoint_to_host_action => 'Accept',
}

This type provides Puppet with the capabilities to manage Calico Felix configuration
EOS
  features: [],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'The name of the resource you want to manage.',
      behaviour: :namevar,
    },
    default_endpoint_to_host_action: {
      type: 'String',
      desc: 'Controls what happens to traffic that goes from a workload endpoint to the host itself.',
      default: 'Drop',
    },
  },
)

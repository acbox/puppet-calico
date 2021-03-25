# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'calico_host_endpoint',
  docs: <<-EOS,
@summary a calico_host_endpoint type
@example
calico_host_endpoint { 'vagrant':
  expectedips => ['10.2.0.15'],
  node        => 'vagrant',
  labels      => {'role' => 'demo'},
}

This type provides Puppet with the capabilities to manage Calico host endpoints.
EOS
  features: [],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether the node should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'The name of the host endpoint you want to manage.',
      behaviour: :namevar,
    },
    labels: {
      type: 'Optional[Hash[String, String]]',
      desc: 'A set of labels to apply to this endpoint.',
      default: {},
    },
    node: {
      type: 'String',
      desc: 'The name of the node where this host endpoint resides.',
    },
    expectedips: {
      type: 'Array[String]',
      desc: 'The expected IP addresses associated with the interface.',
    },
  },
)

# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'calico_ip_pool',
  docs: <<-EOS,
@summary a calico_ip_pool type
@example
calico_ip_pool { 'myippool':
  cidr => '10.10.0.0/16',
}

This type provides Puppet with the capabilities to manage Calico IP pools.
EOS
  features: [],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this IP pool should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'The name of the IP pool you want to manage.',
      behaviour: :namevar,
    },
    cidr: {
      type: 'String',
      desc: 'IP range to use for this pool.',
    },
    blocksize: {
      type: 'Integer',
      desc: 'The CIDR size of allocation blocks used by this pool.',
      default: 26,
    },
    ipipmode: {
      type: 'Enum["Always", "CrossSubnet", "Never"]',
      desc: 'The mode defining when IPIP will be used.',
      default: 'Never',
    },
    vxlanmode: {
      type: 'Enum["Always", "CrossSubnet", "Never"]',
      desc: 'The mode defining when VXLAN will be used.',
      default: 'Never',
    },
    nodeselector: {
      type: 'String',
      desc: 'Selects the nodes that Calico IPAM should assign addresses from this pool to.',
      default: 'all()',
    },
  },
)

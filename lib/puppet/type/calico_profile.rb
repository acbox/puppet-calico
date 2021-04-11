# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'calico_profile',
  docs: <<-EOS,
@summary a calico_profile type
@example
calico_profile { 'foo':
  ensure => 'present',
}

This type provides Puppet with the capabilities to manage Calico profiles.
EOS
  features: [],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this profile should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'The name of the profile you want to manage.',
      behaviour: :namevar,
    },
    ingress: {
      type: 'Array[Hash]',
      desc: 'Ordered list of ingress rules applied by profile.',
    },
    egress: {
      type: 'Array[Hash]',
      desc: 'Ordered list of egress rules applied by profile.',
    },
  },
)

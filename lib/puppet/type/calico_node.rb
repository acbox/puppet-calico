# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'calico_node',
  docs: <<-EOS,
@summary a calico_node type
@example
calico_node { 'vagrant':
  ensure => 'present',
  labels => {
    'role' => 'frontend'
  }
}

This type provides Puppet with the capabilities to manage Calico nodes

If your type uses autorequires, please document as shown below, else delete
these lines.
**Autorequires**:
* `Package[foo]`
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
      desc: 'The name of the node you want to manage.',
      behaviour: :namevar,
    },
    labels: {
      type: 'Hash[String, String]',
      desc: 'Hash of labels to apply to the node.',
    },
  },
)

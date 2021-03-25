# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'calico_global_network_policy',
  docs: <<-EOS,
@summary a calico_global_network_policy type
@example
calico_global_network_policy { 'web':
  selector => 'app == "web"',
  order    => 10,
  types    => [ 'Ingress', 'Egress' ],
  ingress  => [
    {
      action => 'allow',
      source => {
        nets => [ '10.0.2.0/24' ],
      },
      destination => {
        ports => [ '443' ],
      }
    }
  ],
  egress   => [
    {
      action => 'allow',
      destination => {
        nets => [ '0.0.0.0/0' ],
      }
    }
  ],
}

This type provides Puppet with the capabilities to manage Calico global network policies.
EOS
  features: [],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this global network policy should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'The name of the global network policy you want to manage.',
      behaviour: :namevar,
    },
    pre_dnat: {
      type: 'Boolean',
      desc: 'Indicates to apply the rules in this policy before any DNAT.',
      default: false,
    },
    apply_on_forward: {
      type: 'Boolean',
      desc: 'Indicates to apply the rules in this policy on forwarded traffic as well as to locally terminated traffic.',
      default: false,
    },
    types: {
      type: 'Array[Enum["Ingress","Egress"]]',
      desc: 'Applies the policy based on the direction of the traffic.',
    },
    selector: {
      type: 'String',
      desc: 'Selects the endpoints to which this policy applies.',
      default: 'all()',
    },
    ingress: {
      type: 'Array[Hash]',
      desc: 'Ordered list of ingress rules applied by policy.',
    },
    egress: {
      type: 'Array[Hash]',
      desc: 'Ordered list of egress rules applied by policy.',
    },
    order: {
      type: 'Integer',
      desc: 'Controls the order of precedence.',
    },
  },
)

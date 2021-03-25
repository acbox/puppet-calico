# frozen_string_literal: true

require 'puppet/util/calico'
require 'puppet/resource_api/simple_provider'
require 'pry-byebug'

# Implementation for the calico_global_network_policy type using the Resource API.
class Puppet::Provider::CalicoGlobalNetworkPolicy::CalicoGlobalNetworkPolicy < Puppet::ResourceApi::SimpleProvider
  include Calico

  def get(context)
    calicoctl(:get, :global_network_policy)
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    calicoctl(:create, :global_network_policy, should)
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
    calicoctl(:patch, :global_network_policy, should)
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
    calicoctl(:delete, :global_network_policy, should)
  end
end

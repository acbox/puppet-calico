# frozen_string_literal: true

require 'puppet/util/calico'
require 'puppet/resource_api/simple_provider'
require 'pry-byebug'

# Implementation for the calico_ip_pool type using the Resource API.
class Puppet::Provider::CalicoIpPool::CalicoIpPool < Puppet::ResourceApi::SimpleProvider
  include Calico

  def get(context)
    calicoctl(:get, :ip_pool)
  end

  def create(context, name, should)
    binding.pry
    context.notice("Creating '#{name}' with #{should.inspect}")
    calicoctl(:create, :ip_pool, should)
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
    calicoctl(:patch, :ip_pool, should)
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
    calicoctl(:delete, :ip_pool, name)
  end
end

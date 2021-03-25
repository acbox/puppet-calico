# frozen_string_literal: true

require 'puppet/util/calico'
require 'puppet/resource_api/simple_provider'
require 'pry-byebug'

# Implementation for the calico_host_endpoint type using the Resource API.
class Puppet::Provider::CalicoHostEndpoint::CalicoHostEndpoint < Puppet::ResourceApi::SimpleProvider
  include Calico

  def get(context)
    calicoctl(:get, :host_endpoint)
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    calicoctl(:create, :host_endpoint, should)
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
    calicoctl(:patch, :host_endpoint, should)
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
    calicoctl(:delete, :host_endpoint, should)
  end
end

# frozen_string_literal: true

require 'puppet/util/calico'
require 'puppet/resource_api/simple_provider'
require 'pry-byebug'

# Implementation for the calico_felix_configuration type using the Resource API.
class Puppet::Provider::CalicoFelixConfiguration::CalicoFelixConfiguration < Puppet::ResourceApi::SimpleProvider
  include Calico

  def get(context)
    calicoctl(:get, :felix_configuration)
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    calicoctl(:create, :felix_configuration, should)
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
    calicoctl(:patch, :felix_configuration, should)
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
    calicoctl(:delete, :felix_configuration, should)
  end
end

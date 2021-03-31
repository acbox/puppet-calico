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

  def canonicalize(context, resources)
    resources.each do |resource|
      # allow ports to be provided as strings inside egress
      # and ingress rules and cast them to integers
      _egress = (resource[:egress]||[]).map do |egress|
        egress["source"]      = egress["source"]||{}
        egress["destination"] = egress["destination"]||{}
        fixnumify(egress)
      end
      resource[:egress] = _egress
      _ingress = (resource[:ingress]||[]).map do |ingress|
        ingress["source"]      = ingress["source"]||{}
        ingress["destination"] = ingress["destination"]||{}
        fixnumify(ingress)
      end
      resource[:ingress] = _ingress
    end
  end

  # adapted from https://stackoverflow.com/a/8878000
  def fixnumify obj
    # only convert into integers non-empty strings that only contain digits
    if obj.respond_to?(:to_i) && (!obj.to_s.empty?) && obj.to_s.scan(/\D/).empty?
      # If we can cast it to a Fixnum, do it.
      obj.to_i
    elsif obj.is_a? Array
      # If it's an Array, use Enumerable#map to recursively call this method
      # on each item.
      obj.map {|item| fixnumify item }
    elsif obj.is_a? Hash
      # If it's a Hash, recursively call this method on each value.
      obj.merge( obj ) {|k, val| fixnumify val }
    else
      # If for some reason we run into something else, just return
      # it unmodified; alternatively you could throw an exception.
      obj
    end
  end
end

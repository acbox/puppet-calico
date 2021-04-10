require 'json'
require 'pry-byebug'

#
# All resource definitions sourced from: https://docs.projectcalico.org/reference/resources/
#

module Calico
  CALICOCTL = "/usr/local/bin/calicoctl"

  #
  # Node
  #

  def calicoctl_create_node(should)
    spec = sprintf(
      '{"apiVersion":"projectcalico.org/v3","kind":"Node","metadata":{"name":%s,"labels":%s},"spec":{}}',
      should[:name].to_json,
      should[:labels].to_json,
    )
    Puppet::Util::Execution.execute("echo '#{spec}' | #{CALICOCTL} create -f -")
  end

  def calicoctl_get_node(*)
    out = JSON.parse(Puppet::Util::Execution.execute("#{CALICOCTL} get node -o json"))
    return out["items"].map do |item| # See APPENDIX{1}
      {
        name: item.dig("metadata", "name"),
        labels: item.dig("metadata","labels")||{},
        ensure: 'present',
      }
    end
  end

  def calicoctl_patch_node(should)
    spec = {
      "metadata" => {
        "labels" => should[:labels] # See APPENDIX{2}
      }
    }
    Puppet::Util::Execution.execute("#{CALICOCTL} patch node #{should[:name]} -p '#{spec.to_json}'")
  end

  def calicoctl_delete_node(name)
    Puppet::Util::Execution.execute("#{CALICOCTL} delete node #{name}")
  end

  #
  # IP Pool
  #

  def calicoctl_create_ip_pool(should)
    spec = sprintf(
      '{"apiVersion":"projectcalico.org/v3","kind":"IPPool","metadata":{"name":%s},"spec":%s}',
      should[:name].to_json,
      {
        cidr:         should[:cidr],
        blockSize:    should[:blocksize],
        ipipMode:     should[:ipipmode],
        vxlanMode:    should[:vxlanmode],
        nodeSelector: should[:nodeselector],
        natOutgoing:  should[:natoutgoing],
      }.to_json,
    )
    Puppet::Util::Execution.execute("echo '#{spec}' | #{CALICOCTL} create -f -")
  end

  def calicoctl_get_ip_pool(*)
    out = JSON.parse(Puppet::Util::Execution.execute("#{CALICOCTL} get ippool -o json"))
    return out["items"].map do |item| # See APPENDIX{3}
      {
        name:         item.dig("metadata", "name"),
        cidr:         item.dig("spec", "cidr"),
        blocksize:    item.dig("spec", "blockSize"),
        ipipmode:     item.dig("spec", "ipipMode"),
        vxlanmode:    item.dig("spec", "vxlanMode"),
        nodeselector: item.dig("spec", "nodeSelector"),
        natoutgoing:  item.dig("spec", "natOutgoing") == 'true',
        ensure:       'present',
      }
    end
  end

  def calicoctl_patch_ip_pool(should)
    spec = {
      spec: {
        cidr:         should[:cidr],
        blockSize:    should[:blocksize],
        ipipMode:     should[:ipipmode],
        vxlanMode:    should[:vxlanmode],
        nodeSelector: should[:nodeselector],
        natOutgoing:  should[:natoutgoing],
      }
    }
    Puppet::Util::Execution.execute("#{CALICOCTL} patch ippool #{should[:name]} -p '#{spec.to_json}'")
  end

  def calicoctl_delete_ip_pool(name)
    Puppet::Util::Execution.execute("#{CALICOCTL} delete ippool #{name}")
  end

  #
  # Host Endpoint
  #

  def calicoctl_create_host_endpoint(should)
    spec = sprintf(
      '{"apiVersion":"projectcalico.org/v3","kind":"HostEndpoint","metadata":{"name":%s,"labels":%s},"spec":{"node":%s,"expectedIPs":%s}}',
      should[:name].to_json,
      should[:labels].to_json,
      should[:node].to_json,
      should[:expectedips].to_json,
    )
    Puppet::Util::Execution.execute("echo '#{spec}' | #{CALICOCTL} create -f -")
  end

  def calicoctl_get_host_endpoint(*)
    out = JSON.parse(Puppet::Util::Execution.execute("#{CALICOCTL} get hostendpoint -o json"))
    return out["items"].map do |item|
      {
        name: item.dig("metadata", "name"),
        labels: item.dig("metadata","labels")||{},
        node: item.dig("spec","node"),
        expectedips: item.dig("spec","expectedIPs")||[],
        ensure: 'present',
      }
    end
  end

  def calicoctl_patch_host_endpoint(should)
    spec = {
      "metadata" => {
        "labels" => should[:labels]
      }
    }
    Puppet::Util::Execution.execute("#{CALICOCTL} patch hostendpoint #{should[:name]} -p '#{spec.to_json}'")
  end

  def calicoctl_delete_host_endpoint(name)
    Puppet::Util::Execution.execute("#{CALICOCTL} delete hostendpoint #{name}")
  end

  #
  # Global Network Policy
  #

  def calicoctl_create_global_network_policy(should)
    spec = sprintf(
      '{"apiVersion":"projectcalico.org/v3","kind":"GlobalNetworkPolicy","metadata":{"name":%s},' +
      '"spec":{"order":%d,"ingress":%s,"egress":%s,"selector":%s,"types":%s,"preDNAT":%s,"applyOnForward":%s}}',
      should[:name].to_json,
      should[:order].to_json,
      should[:ingress].to_json,
      should[:egress].to_json,
      should[:selector].to_json,
      should[:types].to_json,
      should[:pre_dnat].to_json,
      should[:apply_on_forward].to_json,
    )
    Puppet::Util::Execution.execute("echo '#{spec}' | #{CALICOCTL} create -f -")
  end

  def calicoctl_get_global_network_policy(*)
    out = JSON.parse(Puppet::Util::Execution.execute("#{CALICOCTL} get globalnetworkpolicy -o json"))
    return out["items"].map do |item|
      {
        name:             item.dig("metadata", "name"),
        order:            item.dig("spec", "order"),
        ingress:          item.dig("spec", "ingress")||[],
        egress:           item.dig("spec", "egress")||[],
        selector:         item.dig("spec", "selector"),
        types:            item.dig("spec", "types"),
        pre_dnat:         item.dig("spec", "preDNAT")||false,
        apply_on_forward: item.dig("spec", "applyOnForward")||false,
        ensure:           'present',
      }
    end
  end

  def calicoctl_patch_global_network_policy(should)
    spec = {
      "spec" => {
        "order"          => should[:order],
        "ingress"        => should[:ingress],
        "egress"         => should[:egress],
        "selector"       => should[:selector],
        "types"          => should[:types],
        "preDNAT"        => should[:pre_dnat],
        "applyOnForward" => should[:apply_on_forward],
      }
    }
    Puppet::Util::Execution.execute("#{CALICOCTL} patch globalnetworkpolicy #{should[:name]} -p '#{spec.to_json}'")
  end

  def calicoctl_delete_global_network_policy(name)
    Puppet::Util::Execution.execute("#{CALICOCTL} delete globalnetworkpolicy #{name}")
  end

  #
  # Helper
  #

  def calicoctl(action, kind, arg = nil)
    raise "Unknown action: #{action.to_s}" unless [:create, :get, :patch, :delete].include? action
    raise "Unknown kind: #{kind.to_s}" unless [:node, :ip_pool, :host_endpoint, :global_network_policy].include? kind
    begin
      send("calicoctl_#{action}_#{kind}", arg)
    rescue StandardError => e
      puts e.message
      puts e.backtrace
    end
  end
end

__END__

APPENDIX{1}

[3] pry(#<Puppet::Provider::CalicoNode::CalicoNode>)> out["items"]
=> [{"kind"=>"Node",
     "apiVersion"=>"projectcalico.org/v3",
     "metadata"=>{"name"=>"vagrant", "uid"=>"13063624-0ab8-4ff4-8c1c-0424162b6aa2", "resourceVersion"=>"3", "creationTimestamp"=>"2021-03-23T03:50:12Z"},
     "spec"=>{},
     "status"=>{}}]
[4] pry(#<Puppet::Provider::CalicoNode::CalicoNode>)>

APPENDIX{2}

[2] pry(#<Puppet::Provider::CalicoNode::CalicoNode>)> should
=> {:name=>"vagrant", :labels=>{"role"=>"demo"}, :ensure=>"present"}
[3] pry(#<Puppet::Provider::CalicoNode::CalicoNode>)>

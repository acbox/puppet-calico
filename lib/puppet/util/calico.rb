require 'pry-byebug'
require 'json'

module Calico
  CALICOCTL = "/usr/local/bin/calicoctl"

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
        "labels" => should[:labels]
      }
    }
    Puppet::Util::Execution.execute("#{CALICOCTL} patch node #{should[:name]} -p '#{spec.to_json}'")
  end

  def calicoctl(action, kind, should = nil)
    raise "Unknown action: #{action.to_s}" unless [:get, :patch].include? action
    raise "Unknown kind: #{kind.to_s}" unless [:node].include? kind
    send("calicoctl_#{action}_#{kind}", should)
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

# @summary Configure Calico
#
# Configure Calico
#
# @example
#   include calico::configure
class calico::configure (
  String $nodename,
) {

  # Configure calicoctl to connect to etcdv3 on localhost

  file { '/etc/calico/calicoctl.cfg':
    owner => 'root',
    group => 'root',
    mode  => '0755',
    content => @(CONF/L)
      apiVersion: projectcalico.org/v3
      kind: CalicoAPIConfig
      metadata:
      spec:
        datastoreType: "etcdv3"
        etcdEndpoints: "http://127.0.0.1:2379"
      | CONF
  }

  # Configure nodename file used by calico-node container (Felix)
  # Not sure why this doesn't get created automatically, not
  # really any documentation on it, perhaps only in K8s?:

  file { '/var/lib/calico/nodename':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    # VERY important that you do *NOT* add a trailing newline otherwise node name will not be recognised, you
    # will see an error along these lines in the allocation logs coming from the calico CNI plugin
    content => $nodename,
  }

  # Environment variables used by Felix Docker container, calico-node

  file { '/etc/calico/calico.env':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => @("CONF")
      DATASTORE_TYPE=etcdv3
      ETCD_ENDPOINTS=http://127.0.0.1:2379
      CALICO_NODENAME="${nodename}"
      NO_DEFAULT_POOLS="true"
      CALICO_IP=""
      CALICO_IP6=""
      CALICO_AS=""
      | CONF
  }
}

# @summary Run Calico Felix as a Docker container under systemd
#
# Run Calico Felix as a Docker container under systemd
#
# @example
#   include calico::service
class calico::service {
  systemd::unit_file { 'calico-node.service':
    path    => '/etc/systemd/system',
    content => @(CONF/L)
      [Unit]
      Description=calico-node
      After=docker.service
      Requires=docker.service
      
      [Service]
      EnvironmentFile=/etc/calico/calico.env
      ExecStartPre=-/usr/bin/docker rm -f calico-node
      ExecStart=/usr/bin/docker run --net=host --privileged \
       --name=calico-node \
       -e NODENAME=${CALICO_NODENAME} \
       -e IP=${CALICO_IP} \
       -e IP6=${CALICO_IP6} \
       -e AS=${CALICO_AS} \
       -e NO_DEFAULT_POOLS=${NO_DEFAULT_POOLS} \
       -e DATASTORE_TYPE=${DATASTORE_TYPE} \
       -e ETCD_ENDPOINTS=${ETCD_ENDPOINTS} \
       -v /var/log/calico:/var/log/calico \
       -v /var/lib/calico:/var/lib/calico \
       -v /var/run/calico:/var/run/calico \
       -v /run/docker/plugins:/run/docker/plugins \
       -v /lib/modules:/lib/modules \
       -v /etc/pki:/pki \
       calico/node:v3.18.0 /bin/calico-node -felix
 
      ExecStop=-/usr/bin/docker stop calico-node
      
      Restart=on-failure
      StartLimitBurst=3
      StartLimitInterval=60s
      
      [Install]
      WantedBy=multi-user.target
      | CONF
  }

  service { 'calico-node.service':
    ensure    => 'running',
    subscribe => Systemd::Unit_file['calico-node.service'],
  }
}

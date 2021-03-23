# @summary Install Calico
#
# Install Felix and CNI plugin
#
# @example
#   include calico::install
class calico::install (
  String $cni_binary,
) {

  # Base directories

  $dirs = [
    '/etc/calico',
    '/opt/cni',
    '/opt/cni/bin',
    '/opt/cni/config',
    '/var/lib/calico',
    '/var/log/calico',
    '/var/log/calico/cni'
  ]
  file { $dirs:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
  } ->

  # Install calicoctl

  archive { 'calicoctl':
      path          => '/usr/local/bin/calicoctl',
      source        => 'https://github.com/projectcalico/calicoctl/releases/download/v3.18.0/calicoctl',
      extract       => false,
      creates       => '/usr/local/bin/calicoctl',
      cleanup       => 'false',
  } ->
  file { '/usr/local/bin/calicoctl':
      owner => 'root',
      group => 'root',
      mode  => '0755',
  }

  # Install calico and calico-ipam CNI plugins https://docs.projectcalico.org/getting-started/kubernetes/hardway/install-cni-plugin

  archive { 'calico':
      path    => '/opt/cni/bin/calico',
      source  => $cni_binary,
      extract => false,
      creates => '/opt/cni/bin/calico',
      cleanup => 'false',
  } ->
  file { '/opt/cni/bin/calico':
      owner => 'root',
      group => 'root',
      mode  => '0755',
  }

  archive { 'calico-ipam':
    path    => '/opt/cni/bin/calico-ipam',
    source  => 'https://github.com/projectcalico/cni-plugin/releases/download/v3.14.0/calico-ipam-amd64',
    extract => false,
    creates => '/opt/cni/bin/calico-ipam',
    cleanup => 'false',
  } ->
  file { '/opt/cni/bin/calico-ipam':
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }
}

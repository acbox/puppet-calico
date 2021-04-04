# @summary Install Calico and manage policies
#
# Install Calico and manage policies
#
# @example
#   include calico
class calico (
  String $cni_binary = 'https://github.com/projectcalico/cni-plugin/releases/download/v3.18.1/calico-amd64',
  String $nodename   = $::hostname,
) {
  class { '::calico::install':
    cni_binary => $cni_binary,
  } ->
  class { '::calico::configure':
    nodename => $nodename,
  } ->
  class { '::calico::service':
  }
  contain '::calico::service'
}

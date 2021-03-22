# @summary Install Calico and manage policies
#
# Install Calico and manage policies
#
# @example
#   include calico
class calico (
  String $cni_binary = 'https://github.com/projectcalico/cni-plugin/releases/download/v3.18.1/calico-amd64',
  Tuple $resources
) {
  class { '::calico::install':
    cni_binary => $cni_binary,
  } ->
  class { '::calico::configure':
  } ->
  class { '::calico::resources':
    resources => $resources
  }
}

# Puppet Calico

## Table of Contents

1. [Description](#description)
1. [Supported Resources](#supported-resources)
1. [Setup - The basics of getting started with calico](#setup)
    * [What calico affects](#what-calico-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with calico](#beginning-with-calico)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module manages [Calico](https://projectcalico.org/):

 * It runs [Felix](https://docs.projectcalico.org/reference/felix/) in a Docker container called `calico-node` via SystemD
 * Optionally installs Calico dependencies Docker and etcd3
 * Adds types and providers for managing a subset of Calico resources

## Supported resources

| Calico `kind`         | Puppet type                    |
| --------------------- | ------------------------------ |
| `Node`                | `calico_node`                  |
| `HostEndpoint`        | `calico_host_endpoint`         |
| `IPPool`              | `calico_ip_pool`               |
| `GlobalNetworkPolicy` | `calico_global_network_policy` |
| `FelixConfiguration`  | `calico_felix_configuration`   |
| `Profile`             | `calico_profile`               |

## Testing

Run acceptance tests with:

```
PUPPET_INSTALL_TYPE=agent BEAKER_IS_PE=no BEAKER_PUPPET_COLLECTION=puppet6 BEAKER_debug=true BEAKER_set=ubuntu-server-1604-x64 bundle exec rspec spec/acceptance
```

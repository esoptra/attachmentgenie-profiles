# This class can be used install consul components.
#
# @example when declaring the consul class
#  class { '::profiles::orchestration::consul': }
#
# @param checks   Consul checks,
# @param config   Consul config,
# @param options  Additional consul start up flags.
# @param resolv   Configure resolv.conf to use consul.
# @param services Consul services.
# @param version  Version of consul to install.
# @param watches  Consul watches.
class profiles::orchestration::consul (
  Hash $checks    = {},
  Hash $config    = {
    'data_dir'   => '/opt/consul',
    'datacenter' => 'vagrant',
  },
  String $options = '-enable-script-checks -syslog',
  Boolean $resolv = false,
  Hash $services  = {},
  String $version = '0.9.3',
  Hash $watches   = {},
) {
  package { 'unzip':
    ensure => present,
  }
  -> class { '::consul':
    config_hash   => $config,
    extra_options => $options,
    version       => $version,
  }

  create_resources(::consul::check, $checks)
  create_resources(::consul::service, $services)
  create_resources(::consul::watch, $watches)

  if $resolv {
    class { '::dnsmasq': }
    dnsmasq::conf { 'consul':
      ensure  => present,
      content => 'server=/consul/127.0.0.1#8600',
    }

    class { 'resolv_conf':
      domainname  => $::domain,
      nameservers => ['127.0.0.1', '10.0.2.3'],
    }
  }
}

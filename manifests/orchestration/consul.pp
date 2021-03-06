# This class can be used install consul components.
#
# @example when declaring the consul class
#  class { '::profiles::orchestration::consul': }
#
# @param checks       Consul checks,
# @param config       Consul config,
# @param domain       Resolv.conf domain
# @param name_servers Name servers to use in resolv.conf
# @param options      Additional consul start up flags.
# @param resolv       Configure resolv.conf to use consul.
# @param searchpath   Resolv.conf searchpath.
# @param services     Consul services.
# @param version      Version of consul to install.
# @param watches      Consul watches.
class profiles::orchestration::consul (
  Hash $checks = {},
  Hash $config = {
    'data_dir'   => '/opt/consul',
    'datacenter' => 'vagrant',
  },
  Optional[String] $domain = undef,
  Array $name_servers = ['127.0.0.1'],
  String $options = '-enable-script-checks -syslog',
  Boolean $resolv = false,
  Array $searchpath = [],
  Hash $services = {},
  String $version = '1.2.1',
  Hash $watches = {},
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
      prio    => 10,
      content => ['server=/consul/127.0.0.1#8600','server=/10.in-addr.arpa/127.0.0.1#8600','server=/32.172.in-addr.arpa/127.0.0.1#8600'],
,
    }
    dnsmasq::conf { 'azure':
      ensure  => present,
      prio    => 15,
      content => 'server=/ax.internal.cloudapp.net/168.63.129.16',
    }
    dnsmasq::conf { 'esoptra.io':
      ensure  => present,
      prio    => 5,
      content => ['server=/esoptra.io/10.0.1.14','server=/esoptra.io/172.31.1.10','server=/esoptra.io/10.1.10.103'],
    }
    dnsmasq::conf { 'inet1':
      ensure  => present,
      prio    => 99,
      content => ['server=8.8.8.8','server=8.8.4.4'],
    }

    class { 'resolv_conf':
      domainname  => $domain,
      nameservers => $name_servers,
      searchpath  => $searchpath,
    }
  }

}

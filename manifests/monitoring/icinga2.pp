# This class can be used to setup icinga2.
#
# @example when declaring the node role
#  class { '::profiles::monitoring::icinga2': }
#
# @param parent_endpoints  Icinga parents.
# @param client            Is this a icinga client.
# @param database_host     Db host.
# @param database_name     Db name.
# @param database_password Db password.
# @param database_user     Db user.
# @param features          Enabled features.
# @param ipaddress         Primary ipaddress.
# @param manage_repo       Manage icinga repository.
# @param parent_zone       Icinga zone.
# @param plugins_package   Package with plugins to install.
# @param server            Is this a icinga masters.
# @param vars              Icinga vars.
class profiles::monitoring::icinga2 (
  Hash $parent_endpoints,
  Boolean $client = true,
  String $database_host = '127.0.0.1',
  String $database_name = 'icinga2',
  String $database_password = 'icinga2',
  String $database_user = 'icinga2',
  Array $features = [ 'checker', 'command', 'mainlog', 'notification' ],
  String $ipaddress = $::ipaddress,
  Boolean $manage_repo = false,
  String $parent_zone = 'master',
  String $plugins_package = 'nagios-plugins-all',
  Boolean $server = false,
  Hash $vars = {},
) {
  if $server {
    $constants = {
      'ZoneName' => 'master',
    }
    $zones = {
      'ZoneName' => {
        'endpoints' => [ 'NodeName' ],
      }
    }
  } else {
    $constants = {}
    $zones = {
      'ZoneName' => {
        'endpoints' => [ 'NodeName' ],
        'parent'    => $parent_zone,
      }
    }
  }


  package { 'nagios-plugins-all':
    name => $plugins_package,
  }

  class { '::icinga2':
    confd       => false,
    constants   => $constants,
    features    => $features,
    manage_repo => true,
  }

  class { '::icinga2::feature::api':
    accept_config   => true,
    accept_commands => true,
    zones           => $zones,
  }

  icinga2::object::zone { ['global-templates', 'linux-commands']:
    global => true,
    order  => '47',
  }

  if $client {
    if !($server) {
      create_resources('icinga2::object::endpoint', $parent_endpoints)

      ::icinga2::object::zone { $parent_zone:
        endpoints => keys($parent_endpoints),
      }

      @@::icinga2::object::endpoint { $::fqdn:
        target => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
      }

      @@::icinga2::object::zone { $::fqdn:
        endpoints => [ $::fqdn ],
        parent    => $parent_zone,
        target    => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
      }
    }

    @@::icinga2::object::host { $::fqdn:
      address      => $ipaddress,
      display_name => $::hostname,
      import       => ['linux-host'],
      target       => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
      vars         => $vars,
    }
  }

  if $server {

    class { 'icinga2::feature::idopgsql':
      host          => $database_host,
      user          => $database_user,
      password      => $database_password,
      database      => $database_name,
      import_schema => true,
    }

    ::icinga2::object::apiuser { 'root':
      password    => 'icinga',
      permissions => [ '*' ],
      target      => "/etc/icinga2/zones.d/${parent_zone}/api-users.conf",
    }

    file { ['/etc/icinga2/zones.d/master',
      '/etc/icinga2/zones.d/linux-commands',
      '/etc/icinga2/zones.d/global-templates']:
      ensure => directory,
      owner  => 'icinga',
      group  => 'icinga',
      mode   => '0750',
      tag    => 'icinga2::config::file',
    }

    ::icinga2::object::service { 'ping4':
      import        => ['generic-service'],
      apply         => true,
      check_command => 'ping',
      assign        => ['host.address'],
      target        => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'ping6':
      import        => ['generic-service'],
      apply         => true,
      check_command => 'ping',
      assign        => ['host.address6'],
      target        => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_load':
      import           => ['generic-service'],
      service_name     => 'load',
      apply            => true,
      check_command    => 'load',
      command_endpoint => 'host.name',
      assign           => ['host.address'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_disks':
      import           => ['generic-service'],
      apply            => 'disk_name => config in host.vars.disks',
      check_command    => 'disk',
      command_endpoint => 'host.name',
      vars             => 'vars + config',
      assign           => ['host.address'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    # Collect objects
    ::Icinga2::Object::Endpoint <<| |>>
    ::Icinga2::Object::Zone <<| |>>
    ::Icinga2::Object::Host <<| |>>

    # Static config files
    file { '/etc/icinga2/zones.d/global-templates/templates.conf':
      ensure => file,
      owner  => 'icinga',
      group  => 'icinga',
      mode   => '0640',
      source => 'puppet:///modules/profiles/monitoring/icinga2/templates.conf',
    }
  }
}

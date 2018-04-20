# This class can be used install fail2ban
#
# @example when declaring the apache class
#  class { '::profiles::bootstrap::fail2ban': }
#
# @param services Services to control.
# @param subnets  Subnets to be whitelisted.
# @param f2b      Load config file
class profiles::bootstrap::fail2ban (
  Array $services =['ssh', 'ssh-ddos'],
  Array $subnets =['127.0.0.1/8', '10.0.0.0/16', '172.31.1.0/24', '81.83.16.118/32', '61.12.36.234/32'],
  Boolean $f2b = false,
) {
  if $f2b {
    class { 'fail2ban':
      config_file_template => "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
    }
  }
  class { '::fail2ban':
    jails     => $services,
    whitelist => $subnets,
  }
}
    

# This class can be used install fail2ban
#
# @example when declaring the apache class
#  class { '::profiles::bootstrap::fail2ban': }
#
# 
class profiles::bootstrap::fail2ban (
  Array $services =['ssh', 'ssh-ddos', 'nginx'],
) {
  class { '::fail2ban':
    jails => $services
  }
}

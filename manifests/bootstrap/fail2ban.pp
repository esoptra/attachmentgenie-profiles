# This class can be used install fail2ban
#
# @example when declaring the apache class
#  class { '::profiles::bootstrap::fail2ban': }
#
# @param services Services to control.
# @param config_file_template overide config template
# @param action   Set default action
# @param bantime  Set Time to ban ip 
# @param email    Set receiving and sending email address
# @param jails    Enable specified jails
# @param maxretry Set amount of retries before banning
# @param whitelist  Set ip's/ subnets to be ignored by fail2ban

class profiles::bootstrap::fail2ban (
  String $action                = 'action_mb',
  Integer $bantime              = 600,
  String $config_file_template  = "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
  String $email                 = 'it.admin@esoptra.com',
  Array $jails                  =['ssh', 'ssh-ddos'],
  Integer $maxretry             = 5,
  Array $whitelist              =['127.0.0.1/8', '10.0.0.0/16', '172.31.1.0/24', '192.168.0.0/16', '81.83.16.118/32', '61.12.36.234/32'],
) { class { '::fail2ban':
    action               => $action,
    bantime              => $bantime,
    config_file_template => $config_file_template,
    email                => $email,
    jails                => $jails,
    maxretry             => $maxretry,
    whitelist            => $whitelist,
  }
}

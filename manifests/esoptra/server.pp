# This class can be used install user esoptra properties
#
# @example when declaring the esoptra class
#  class { '::profiles::esoptra::server': }
#
# @param init_command Command to bootstrap esoptra with (params cloud be set using a seperate variable).
# @param init_environment esoptra environment settings.
# @param init_params Additional parameters to use.
# @param init_user User to run esoptra init as.
# @param pluglets Install pluglets.
# @param webui Install webui.
class profiles::esoptra::server (
  String $init_command = 'esoptra init',
  Array $init_environment = ['HOME=/root','USER=root'],
  String $init_params = '',
  String $init_user = 'root',
  Hash $pluglets = {},
  Boolean $webui = false,
) {
  class { '::esoptra':
    init_command              => $init_command,
    init_environment          => $init_environment,
    init_params               => $init_params,
    init_user                 => $init_user,
    pluglets                  => $pluglets,
    webui                     => $webui,
  }
}

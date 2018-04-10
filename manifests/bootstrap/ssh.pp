# This class can be used install ssh components.
#
# @example when declaring the ssh class
#  class { '::profiles::bootstrap::ssh': }
#
# @param allow_agent_forwarding  Allow forwarding of the agent.
# @param forward_agent           Forward the connection of the agent to the remote machine.
# @param gatewayports            Allow creating SSH tunnels
# @param password_authentication Accept access using password.
class profiles::bootstrap::ssh (
  String $allow_agent_forwarding  = 'no',
  String $forward_agent           = 'no',
  String $gatewayports            = 'no',
  String $password_authentication = 'no',
) {
  class { '::ssh::client':
    forward_agent           => $forward_agent,
    password_authentication => $password_authentication,
  }
  class { '::ssh::server':
    allow_agent_forwarding  => $allow_agent_forwarding,
    password_authentication => $password_authentication,
    gateway_ports            => $gatewayports
  }
}

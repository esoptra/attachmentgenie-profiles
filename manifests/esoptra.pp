# This class can be used install esoptra components.
#
# @example when declaring the esoptra class
#  class { '::profiles::esoptra': }
#
# @param server Manage esoptra on this node.
class profiles::esoptra (
  Boolean $server = false,
) {
  if $server {
    class { '::profiles::esoptra::server': }
  }
}

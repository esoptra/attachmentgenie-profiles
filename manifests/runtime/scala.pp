# This class can be used install scala components.
#
# @example when declaring the scala class
#  class { '::profiles::runtime::scala': }
#
# @param development Manage development packages on this node.
class profiles::runtime::scala (
  Boolean $development = false,
) {
  package { 'scala':
    ensure   => present,
    provider => 'rpm',
    source   => 'http://downloads.lightbend.com/scala/2.10.6/scala-2.10.6.rpm',
  }
  if $development {
    yumrepo { 'bintray--sbt-rpm':
      descr    => 'bintray--sbt-rpm',
      baseurl  => 'http://dl.bintray.com/sbt/rpm',
      enabled  => 1,
      gpgcheck => 0,
    }
    -> package { 'sbt':
      ensure   => present,
    }
  }
}

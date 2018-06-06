# This class is used to add a bash completition file.
#
#

class profiles::orchestration::short_hosts {

  file { '/etc/bash_completion.d/short_hosts':
    ensure  => 'file',
    replace => 'yes',
    source  => 'puppet:///modules/profiles/files/short_hosts',
  }
}
# == Class: nagiosxi::params
#
class nagiosxi::params {
  case $os['family'] {
    'RedHat': {
      $rpmrepo_url = 'https://repo.nagios.com/nagios/7/nagios-repo-7-2.el7.noarch.rpm'
    }
    default: {
      fail("Sorry, ${os['family']} is not supported.")
    }
  }
}

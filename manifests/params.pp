# == Class: nagiosxi::params
#
class nagiosxi::params {
  $mysqldb_innodb_buffer_pool_size = '4096M'
  $mysqldb_innodb_log_file_size    = '1024M'
  $mysqldb_innodb_log_buffer_size  = '32M'
  $mysqldb_max_allowed_packet      = '16M'
  $mysqldb_max_connections         = '2048'

  case $::os['family'] {
    'RedHat': {
      $rpmrepo_url = 'https://repo.nagios.com/nagios/7/nagios-repo-7-2.el7.noarch.rpm'
    }
    default: {
      fail("Sorry, ${os['family']} is not supported.")
    }
  }
}

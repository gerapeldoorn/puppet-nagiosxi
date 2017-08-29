# Class: nagiosxi
# ===========================
#
# Full description of class nagiosxi here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'nagiosxi':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
# TODO: Redirect apache / -> /nagiosxi
# TODO: SSL
class nagiosxi(
  $nagios_url,
  $nagios_apikey,
  $rpmrepo_url                     = $nagiosxi::params::rpmrepo_url,
  $mysqldb_innodb_buffer_pool_size = $nagiosxi::params::mysqldb_innodb_buffer_pool_size,
  $mysqldb_innodb_log_file_size    = $nagiosxi::params::mysqldb_innodb_log_file_size,
  $mysqldb_innodb_log_buffer_size  = $nagiosxi::params::mysqldb_innodb_log_buffer_size,
  $mysqldb_max_allowed_packet      = $nagiosxi::params::mysqldb_max_allowed_packet,
  $mysqldb_max_connections         = $nagiosxi::params::mysqldb_max_connections,
) inherits nagiosxi::params {

  class { 'mysql::server':
    package_name            => 'mariadb-server',
    service_name            => 'mariadb',
    override_options        => {
      'mysqld' => {
        'innodb_buffer_pool_size' => $mysqldb_innodb_buffer_pool_size,
        'innodb_log_file_size'    => $mysqldb_innodb_log_file_size,
        'innodb_log_buffer_size'  => $mysqldb_innodb_log_buffer_size,
        'max_allowed_packet'      => $mysqldb_max_allowed_packet,
        'max_connections'         => $mysqldb_max_connections,
      },
    },
  }

  ensure_resource( 'package', 'nagios-repo', {
    'ensure'   => 'installed',
    'source'   => $rpmrepo_url,
    'provider' => 'rpm',
  })
  
  package { 'nagiosxi':
    ensure  => installed,
    require => [Class['mysql::server'], Package['nagios-repo'] ],
  }

  sudo::conf { 'nagiosxi':
    source => 'puppet:///modules/nagiosxi/sudoers',
  }

}

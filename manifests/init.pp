# Class: nagiosxi
# ===========================
#
# Manages NagiosXI server.
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
# Examples
# --------
#
# @example
#    class { 'nagiosxi':
#      nagios_url => 'https://mynagios.example.com',
#    }
# Hieradata
# ---------
#    nagiosxi::nagios_url   : http://mynagios.example.com
#    nagiosxi::nagios_apikey: 1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd
#
# Authors
# -------
#
# Ger Apeldoorn <info@gerapeldoorn.nl>
#
# Copyright
# ---------
#
# Copyright 2017 Ger Apeldoorn, unless otherwise noted.
#
# TODO: Redirect apache / -> /nagiosxi
# TODO: SSL
class nagiosxi(
  $nagios_url,
  $nagios_apikey,
  $pkgversion                      = 'installed',
  $rpmrepo_url                     = $nagiosxi::params::rpmrepo_url,
  $mysqldb_innodb_buffer_pool_size = $nagiosxi::params::mysqldb_innodb_buffer_pool_size,
  $mysqldb_innodb_log_file_size    = $nagiosxi::params::mysqldb_innodb_log_file_size,
  $mysqldb_innodb_log_buffer_size  = $nagiosxi::params::mysqldb_innodb_log_buffer_size,
  $mysqldb_max_allowed_packet      = $nagiosxi::params::mysqldb_max_allowed_packet,
  $mysqldb_max_connections         = $nagiosxi::params::mysqldb_max_connections,
) inherits nagiosxi::params {

  class { 'mysql::server':
    package_name     => 'mariadb-server',
    service_name     => 'mariadb',
    override_options => {
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
    ensure  => $pkgversion,
    require => [Class['mysql::server'], Package['nagios-repo'] ],
  }

  file { '/var/www/html/index.php':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/nagiosxi/index.php',
  }

  sudo::conf { 'nagiosxi':
    source => 'puppet:///modules/nagiosxi/sudoers',
  }

}

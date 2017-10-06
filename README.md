# nagiosxi

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Module to do a basic installation of NagiosXI through RPM packages on RHEL.

## Usage
```puppet
include nagiosxi
```

```yaml
nagiosxi::nagios_url   : http://nagios.example.com
nagiosxi::nagios_apikey: ---YOUR APIKEY--- (only required when using exported resources for host creation)
nagiosxi::xi_admin_email: myemail@example.com
nagiosxi::xi_admin_description: My Name
nagiosxi::xi_admin_timezone: Europe/Amsterdam
nagiosxi::xi_admin_password: SuperSecret
```

In your base profile:

```puppet
  @@nagiosxi::host { $::clientcert:
    address              => $::clientcert,
    nagios_alias         => $profile::base::role,
    nagios_host_template => '00_LinuxHost',
    tag                  => $::serverid[0],
  }
```

In your nagios profile:

```puppet
Nagiosxi::Host<<| |>>
```


## Limitations

Not widely tested (yet), just CentOS 7.

## Development

Feel free to submit PR's

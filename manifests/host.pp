# == Define: nagiosxi::host
#
# This resource defines a Nagios host. You can export this on all managed hosts and import it in your profile
# Host <<| |>>
define nagiosxi::host (
  $ip,
  $nagios_alias,
  $nagios_host_template,
) {
  exec { "nagiosxi_host_${title}":
    command => "curl -XPOST \"${nagiosxi::nagios_url}/nagiosxi/api/v1/config/host?apikey=${nagiosxi::nagios_apikey}\" -d \"host_name=${title}&address=${ip}&alias=${nagios_alias}&use=${nagios_host_template}&force=1&applyconfig=1\"",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    onlyif  => "curl -s -XGET \"${nagiosxi::nagios_url}/nagiosxi/api/v1/objects/host?apikey=${nagiosxi::nagios_apikey}&host_name=${title}\" | grep '\"recordcount\":\"0\"'",
  }
}

# curl -XPOST "http://${nagiosxi::nagios_url}/nagiosxi/api/v1/config/host?apikey=${nagiosxi::nagios_apikey}" -d "host_name=${title}&address=${ip}&alias=${nagios_alias}&use=${nagios_host_template}&force=1&applyconfig=1"

# Check
# curl -XGET "http://${nagiosxi::nagios_url}/nagiosxi/api/v1/config/host?apikey=${nagiosxi::nagios_apikey}&host_name=testapihosta_bestaatniet" | grep \"0\"

# curl -XGET "http://hs-mon-gen-001.hs.nl/nagiosxi/api/v1/config/host?apikey=6HZ3rbZj66aOlU4883qV2EKkWuUBr7FA4ESu5R8reBfCLCZSVK4WE4BARroiB38E&host_name=hs-test-gen-008.funix.nl"

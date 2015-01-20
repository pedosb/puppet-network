# == Definition: network::if::bridge
#
# Creates a normal, bridge interface.
#
# === Parameters:
#
#   $ensure        - required - up|down
#   $bridge        - required - bridge interface name
#   $userctl       - optional - defaults to yes
#
# === Actions:
#
# Deploys the file /etc/sysconfig/network-scripts/ifcfg-$name.
#
# === Sample Usage:
#
#   network::tap::bridge { 'tap0':
#     ensure => 'up',
#     bridge => 'br0'
#   }
#
# === Authors:
#
# Pedro Batista <pedosb@gmail.com>
#
# === Copyright:
#
# Copyright (C) 2015 Pedro Batista, unless otherwise noted.
#
define network::if::bridge (
  $ensure,
  $bridge,
  $userctl=false,
  $bootproto='none',
  $onboot=yes,
) {
  # Validate our regular expressions
  $states = [ '^up$', '^down$' ]
  validate_re($ensure, $states, '$ensure must be either "up" or "down".')
  validate_bool($userctl)
  validate_bool($onboot)
  $interface=$name
  file { "ifcfg-${interface}":
    ensure    => 'present',
    mode       => '0644',
    owner    => 'root',
    group     => 'root',
    path    => "/etc/sysconfig/network-scripts/ifcfg-${interface}",
    content  => template('network/ifcfg-tap.erb'),
    notify => Service['network'],
  }
} # define network::if::bridge

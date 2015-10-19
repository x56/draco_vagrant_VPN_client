class client_fw::pre {
  Firewall {
    require => undef,
  }
   # Default firewall rules
  firewall { '000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    action      => 'reject',
  }->
  firewallchain { 'FW_eth0_INPUT':
    ensure  => 'present',
  }->
  firewall { '003 forward to FW_eth0_INPUT':
    chain   => 'INPUT',
    iniface => 'eth0',
    jump    => 'FW_eth0_INPUT',
  }->
  firewallchain { 'FW_tun0_INPUT':
    ensure => 'present',
  }-> 
  firewall { '004 forward to FW_tun0_INPUT':
    chain   => 'INPUT',
    iniface => 'tun0',
    jump    => 'FW_tun0_INPUT',
  }
}
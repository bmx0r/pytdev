stage { pre: before => Stage[main] }

node default{
 require  infra::base
 require  infra::database

vcsrepo { '/home/vagrant/python-nmap-lib':
 	ensure   => present,
  provider => git,
	source   => 'https://github.com/savon-noir/python-nmap-lib.git',
	owner => 'vagrant',
	group =>  'vagrant',  
	require => Package["git"]
	}
vcsrepo { '/home/vagrant/python-libnessus':
 	ensure   => present,
  provider => git,
	source   => 'https://github.com/bmx0r/python-libnessus.git',
	owner => 'vagrant',
	group =>  'vagrant',  
	require => Package["git"]
	}

vcsrepo { '/opt/kibana':
 	ensure   => present,
  	provider => git,
	source   => 'https://github.com/elasticsearch/kibana.git',
	owner => 'apache',
	group =>  'apache',  
	require => Package["git"],
	}
# we need the repo before configuring apache
#Class['vcsrepo::/opt/kibana'] -> Class['apache']

file { "/etc/motd":
    owner   => root,
    group   => root,
    mode    => 644,
    ensure  => present,
	  content => "HELLO WORLD..."
  }

}

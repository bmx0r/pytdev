stage { pre: before => Stage[main] }

node default{
 require  infra::base
 require  infra::database

#class { 'rabbitmq::server':
#        version    => "3.1.1",
#    }
#

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
#	source   => 'git@github.com:bmx0r/python-libnessus.git',
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


# If you want to update the VM after provision uncomment the following
# May provoque issue with Vbox (like the dpkms and vbox guest software)
# class { 'yumupdate':
#    stage => pre
#  }

#environment
file { "/etc/environment":
        owner   => root,
        group   => root,
        mode    => 644,
        ensure  => present,
	content => "
                    LANG=en_US.utf-8
                    LC_ALL=en_US.utf-8
                   ",
    }
file { "/etc/motd":
	owner   => root,
        group   => root,
        mode    => 644,
        ensure  => present,
	content => "
			HELLO WORLD HERE IS YOUR PYTHON DEV BOX
		   "
  }

}

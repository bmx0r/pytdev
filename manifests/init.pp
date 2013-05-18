stage { pre: before => Stage[main] }

node default{
 require  infra::base
 require  infra::database

vcsrepo { '/home/vagrant/':
 	ensure   => present,
  	provider => git,
  	source   => 'git@github.com:savon-noir/python-nmap-lib.git',
	owner => 'vagrant',
	group =>  'vagrant',  
	require => ,Package["git"]]
	}

'/home/vagrant' -> Package["git"]

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

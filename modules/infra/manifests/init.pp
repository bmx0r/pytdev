class infra{

class database{
    require  infra::base

#elasticSearch
class { 'elasticsearch':
        config                   => {
          'node'                 => {
                'name'                 => $::hostname
                                },
                'index'                => {
                                    'number_of_replicas' => '0',
                                    'number_of_shards'   => '5'
                                            },
               # 'network'              => {
               #                     'host'               => '192.168.33.10'
               #                           }
                 'cluster'            => {
                                    'name'             => 'ESClusterName',
                                        },
                                   },
         status   => 'running',
         java_install => true,
         manage_repo  => true,
         repo_version => '1.1',
        }
elasticsearch::plugin{'mobz/elasticsearch-head':
   module_dir => 'head'
    }

}

# base list all the commun package/file/tool
class base(
 $requirements="/tmp/allpython.txt",
 $requirements_template="infra/requirements.txt"
	) {
    include epel
    file { $requirements:
		ensure => "present",
    		content => template($requirements_template),
	}

  package{
	'distribute':
		provider => pip,
		ensure => latest;
	}
    pip::install {"allpython":
    	requirements => $requirements,
    	require => [Package["distribute"],Package["python-pip"],File[$requirements],Package["python-devel"]],
	}

    #package needed from the distro:
    package {
	'gcc':
		ensure => present;
	'nmap':
		ensure => present;
	'vim-enhanced':
		ensure => present;
	'git':
		ensure => present;
	'python-devel':
		ensure => present;
	'python-setuptools':
		ensure => present,
		require => Yumrepo["epel"];
	'python-pip':
		ensure => present,
		require => [ Yumrepo["epel"],
			     Package["python-devel"]
			];
	}

    #Apache
    class { 'apache':
            default_vhost        => false,
                    }
                    apache::vhost { 'kibana.example.com':
                                    port          => '80',
                                    docroot       => '/opt/kibana',
                                    docroot_owner => 'apache',
                                    docroot_group => 'apache',
                                  }
  }
}

class infra{

class database{
    require  infra::base

# elasticSearch
class { 'elasticsearch':
  java_install => true,
  manage_repo  => true,
  repo_version => '1.1',
  datadir => '/var/lib/elasticsearch-data'
}
elasticsearch::instance { 'es-01':
  config => {
          'node' => {
            'name' => $::hostname
                     },
           'index' => {
                       'number_of_replicas' => '0',
                       'number_of_shards'   => '5'
                      },
           'cluster' => {
                         'name' => 'ESClusterName',
                         },
          },
  status   => 'enabled',
}
elasticsearch::plugin{'mobz/elasticsearch-head':
  module_dir => 'head',
  instances => ['es-01'],
}
elasticsearch::plugin{'karmi/elasticsearch-paramedic':
  module_dir => 'paramedic',
  instances => ['es-01'],
}
#elasticsearch::python { 'elasticsearch':; }
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
  'setuptools':
		provider => pip,
		ensure => latest,
    require => [Package['python-pip']],
	}
    pip::install {"allpython":
    	requirements => $requirements,
    	require => [Package["distribute"],Package["python-pip"],File[$requirements],Package["python-devel"],Package['setuptools']],
	}

    # package needed from the distro:
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

    # Apache
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

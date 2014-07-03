class infra{

class database{
    require  infra::base
    #setup the mysql DB
    class { 'mysql::server':
          config_hash => { 'root_password' => 'foo' }
      }
    mysql::db { 'ninaval':
          user     => 'ninaval',
          password => 'ninaval',
          host     => 'localhost',
          grant    => ['all'],
        }
    class { 'mysql': }
   
# setup mongodb
class { 'mongodb':
     enable_10gen => true,
   }

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
#class { 'rabbitmq::repo::rhel':
#        version    => "2.8.4",
#        relversion => "1",
#    }
#
##add rabbitmq
#class { 'rabbitmq::server':
#      delete_guest_user => false,
#    }

class webfront{
#this class will setup python/django/django-celery/rabbitmq/apache+modwsgi/mysqlclient/the APP... all needed to the web
    require  infra::base

    class { "celery::django":
      require =>  Class["celery::rabbitmq"],
      broker_user => "celery",
      broker_vhost => "celeryamqp",
      broker_password => "velovspatin",
    }

    class { "celery::rabbitmq":
      user => "celery",
      vhost => "celeryamqp",
      password => "velovspatin",
    }
   package {
	'httpd':
		ensure => present;
	'mod_wsgi':
		ensure => present;
           }
 include infra::ninaval

}

class worker{
#a worker is a celery worker, this will probably need a rabbitmq, celery or dj-celery, the scanning tools, will probably need the app or a part of the application
    require  infra::base
    #In the future uncomment (when nmap removed from the infra::base
    #package {
    #    'nmap':
    #           ensure => present;
    #}
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
#    file { "/usr/bin/pip":
#	ensure => link,
#	#require => Package["python-pip"],
#	target => "/usr/bin/pip-python",
#	}
    package{
	'distribute':
		provider => pip,
		ensure => latest;
	}
    pip::install {"allpython":
    	requirements => $requirements,
    	require => [Package["distribute"],Package["python-pip"],File[$requirements],Package["mysql-devel"],Package["python-devel"]],
	}

    #package needed from the distro:
    package {
	'gcc':
		ensure => present;
	'nmap':
		ensure => present;
	'vim-enhanced':
		ensure => present;
	'mysql-devel':
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

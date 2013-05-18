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
    class mongodb {
      enable_10gen => true,
    }

}

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
    file { "/usr/bin/pip":
	ensure => link,
	require => Package["python-pip"],
	target => "/usr/bin/pip-python",
	}
    package{
	'distribute':
		provider => pip,
		ensure => latest;
	}
    pip::install {"allpython":
    	requirements => $requirements,
    	require => [File["/usr/bin/pip"],Package["distribute"],Package["python-pip"],File[$requirements],Package["mysql-devel"],Package["python-devel"]],
	}

    #package needed from the distro:
    package {
	'gcc':
		ensure => present;
	'nmap':
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
  }
}

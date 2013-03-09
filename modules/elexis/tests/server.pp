notify { "test: elexis::mysql_server": }

# include elexis::mysql_server
include mysql
class { 'mysql::mysql_server':
  config_hash => { 'root_password' => 'elexisTest' }
}
include elexis::common
class elexis::mysql_server {
  mysql::db { 'myElexis3':
    user     => 'elexis',
    password => mysql_password('elexisTest'),
    host     => 'localhost',
    grant    => ['all'],
    require => User['elexis'],
  }


  database_user{ 'vagrant@localhost':
    ensure        => present,
    password_hash => mysql_password('vagrant'),
    require       => Class['mysql::server'],
  }


  mysql::db { 'mydb':
    user     => 'myuser',
    password => 'mypass',
    host     => 'localhost',
    grant    => ['all'],
  }
  database_grant{'test1@localhost/redmine':
    privileges => [update],
  }

}
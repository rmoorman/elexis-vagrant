class { 'elexis':
  java               => 'openjdk-7-jdk'
}
$users_devel        = hiera('users_devel')
elexis::users  {"developement users": user_definition       => $users_devel}

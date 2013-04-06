# Downloads various variants of the eclipse
notify { "This is elexis::download_eclipse_version": }
require jenkins
require elexis::common

define elexis::download_eclipse_version(
  $baseURL,
  $file_base = $title,
  $downloadDir = "/opt/jenkins/downloads"
 ) {
  $fullName = "$downloadDir/$filename"
  $cmd = "wget --timestamping "
  notify {"version-cmd  ${cmd} title ${title} from ${baseURL}":}
  include jenkins
  if !defined(Exec["create_$downloadDir"]) {
    exec { "create_$downloadDir":
      command => "mkdir -p ${downloadDir}",
      path => '/usr/bin:/bin',
      unless => "test -d ${downloadDir}"
    }
  }


  # default for the execs
  Exec {
    cwd     => $downloadDir,
    path    => '/usr/bin:/bin',
    user    => $jenkins::jenkinsUser,
    group   => $jenkins::jenkinsUser,
  }

  $win32 = "win32.zip"
  exec { "${file_base}-$win32":
    command => "${cmd} ${baseURL}/${title}-$win32",
    creates => "${downloadDir}/${title}-$win32",
  }

  $linux32 = "linux-gtk.tar.gz"
  exec { "${file_base}-$linux32":
    command => "${cmd} ${baseURL}/${title}-$linux32",
    creates => "${downloadDir}/${title}-$linux32",
  }

  $linux64 = "linux-gtk-x86_64.tar.gz"
  exec { "${file_base}-$linux64":
    command => "${cmd} ${baseURL}/${title}-$linux64",
    creates => "${downloadDir}/${title}-$linux64",
  }

  $macosx64 = "macosx-cocoa-x86_64.tar.gz"
  exec { "${file_base}-$macosx64":
    command => "${cmd} ${baseURL}/${title}-$macosx64",
    creates => "${downloadDir}/${title}-$macosx64",
  }

  # install elexis for the current OS/arch
  case downcase("${kernel}.${architecture}") {
    /linux.i386/:	{ $ext = $linux32 }
    /linux.amd64/:	{ $ext = $linux64 }
    /macosx/:		{ $ext = $macosx64 }
    default: 		{ $ext = $win32 }
  }

  $instDir = "/opt/eclipse/${title}"
  file {[$instDir]:
    ensure => directory,
  }
  if !defined(File[dirname($instDir)]) {
    file {[dirname($instDir)]:
      ensure => directory,
    }
  }

  $tarName = "${downloadDir}/${title}-${ext}"
  $unpackCmd = "tar -zxvf ${downloadDir}/${title}-${ext}"
  exec{$title:
    cwd => $instDir,
    command => $unpackCmd,
    creates => ["${instDir}/eclipse/eclipse", "${instDir}/eclipse"],
    path => '/usr/bin:/bin',
    require => Exec["${title}-${ext}"],
  }

  file {"${instDir}/eclipse":
    require => Exec[$title],
  }

  # create a logical link for easier startup if we are using the as a real developer
  file {"/usr/local/bin/${title}":
    ensure => link,
    target => "${instDir}/eclipse/eclipse",
  }
}
class httpd (
  $message = 'My super fantastic message',
) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  #exec { 'echo This is an exec test!':
  #  path => '/bin',
  #} 

  notify { "$message": }

  package { 'httpd':
    ensure => present,
  }

  file { '/var/www/html':
    ensure  => directory,
    mode    => '0777',
    require => Package['httpd'],
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    #content => 'Puppet is awesome!!!!!!',
    #source  => 'puppet:///modules/httpd/index.html',
    content => epp('httpd/index.html.epp', { message => $message }), 
    require => File['/var/www/html'],
  }

  service { 'httpd':
    ensure    => running,
    enable    => true,
    subscribe => File['/var/www/html/index.html'],
  }
}

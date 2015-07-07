class django::supervisord (

  $service_enable = $django::params::supervisord_service_enable,
  $service_ensure = $django::params::supervisord_service_ensure,
  $package_ensure = $django::params::supervisord_package_ensure,

  $package_name   = $django::params::supervisord_package_name,
  $service_name   = $django::params::supervisord_service_name,

  $confdir        = $django::params::supervisord_confdir,

) {

  include '::django'

  if $::django::manage_supervisord {

    package { $package_name:
      ensure => $package_ensure,
    }

    service { $service_name:
      ensure  => $service_ensure,
      enable  => $service_enable,
      require => Package[$package_name],
    }

  }
  
}

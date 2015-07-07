class django::supervisord (

  $supervisord_service_enable = $django::params::supervisord_service_enable,
  $supervisord_service_ensure = $django::params::supervisord_service_ensure,
  $supervisord_package_ensure = $django::params::supervisord_package_ensure,

  $supervisord_package_name   = $django::params::supervisord_package_name,
  $supervisord_service_name   = $django::params::supervisord_service_name,

  $supervisord_confdir        = $django::params::supervisord_config,

) {

  include '::django'

  if $::django::manage_supervisord {

    package { $supervisord_package_name:
      ensure => $supervisord_package_ensure,
    }

    service { $supervisord_service_name:
      ensure  => $supervisord_service_ensure,
      enable  => $supervisord_service_enable,
      require => Package[$supervisord_package_name],
    }

  }
  
}

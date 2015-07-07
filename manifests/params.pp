class django::params {
  $manage_supervisord               = true

  $supervisord_service_enable       = true
  $supervisord_service_ensure       = 'running'
  $supervisord_package_ensure       = 'present'
  $default_supervisord_package_name = [ 'supervisor' ]
  $default_supervisord_service_name = 'supervisor'

  $default_supervisord_confdir      = '/etc/supervisor/conf.d'

  case $::osfamily {
    'Debian': {
      $supervisord_package_name = $default_supervisord_package_name
      $supervisord_service_name = $default_supervisord_service_name

      $supervisord_confdir      = $default_supervisord_confdir
    }

    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }

}

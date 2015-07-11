class django::supervisord (

  $service_enable = $django::params::supervisord_service_enable,
  $service_ensure = $django::params::supervisord_service_ensure,
  $package_ensure = $django::params::supervisord_package_ensure,

  $package_name   = $django::params::supervisord_package_name,
  $service_name   = $django::params::supervisord_service_name,

  $confdir        = $django::params::supervisord_confdir,

) inherits django::params {
    
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_string($package_ensure)
  validate_string($package_name)
  validate_string($service_name)
  validate_absolute_path($confdir)
  
  package { $package_name:
    ensure => $package_ensure,
    before => Service[$service_name],
  }

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }

  
}

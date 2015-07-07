class django (
  $apps               = {},

  $manage_supervisord = $django::params::manage_supervisord,

) inherits django::params {

  validate_hash($apps)

  include '::django::supervisord'
 
  create_resources(django::app, $apps)

}

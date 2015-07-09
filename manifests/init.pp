class django (
  $apps               = {},
  $workers            = {},

  $manage_supervisord = $django::params::manage_supervisord,

) inherits django::params {

  validate_hash($apps)
  validate_hash($workers)

  include '::django::supervisord'

  create_resources(django::app, $apps)
  create_resources(django::celery::worker, $workers)

}

class django (
  $apps,

) inherits django::params {

  validate_hash($apps)

  create_resources(django::app, $apps)

}

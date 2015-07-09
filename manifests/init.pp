class django (
  $apps               = {},
  $workers            = {},
  $beats              = {},
  $users              = {},
  $keys               = {},
  $packages           = {},

  $manage_supervisord = $django::params::manage_supervisord,

) inherits django::params {

  validate_hash($apps)
  validate_hash($workers)

  include '::django::supervisord'

  create_resources(django::app, $apps)
  create_resources(django::celery::worker, $workers)
  create_resources(django::celery::beat, $beats)

  $user_defaults = {
    ensure     => present,
    managehome => true,
    shell      => '/bin/sh',
  }

  create_resources(user, $users, $user_defaults)

  $key_defaults = {
    ensure => present,
    'type' => 'ssh-rsa',
  }

  create_resources(ssh_authorized_key, $keys)

  package { $packages:
    ensure => present,
  }

}

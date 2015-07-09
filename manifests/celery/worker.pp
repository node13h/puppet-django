define django::celery::worker (
  $user,
  $app,
  $log_level          = 'info',

  $launcher_overrides = {},
) {

  include '::django'

  validate_string($user)
  validate_string($app)

  validate_string($log_level)

  validate_hash($launcher_overrides)

  $command = "celery -A ${app} worker -l ${log_level} -n ${name}.%h"

  $launcher_props = {
    user    => $user,
    app     => $app,
    command => $command,
  }

  $launchers = {
    "${name}-celery-worker" => merge($launcher_props, $launcher_overrides)
  }

  create_resources(django::launcher, $launchers)


}

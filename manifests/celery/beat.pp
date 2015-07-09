define django::celery::beat (
  $user,
  $log_level          = 'info',
  $schedule_db_file   = 'celerybeat-schedule',
  $pidfile            = 'celerybeat.pid',

  $launcher_overrides = {},
) {

  include '::django'

  validate_string($user)
  validate_string($log_level)
  validate_hash($launcher_overrides)

  $command = "celery -A ${name} beat -l ${log_level} --pidfile ${pidfile} -s ${schedule_db_file}"

  $launcher_props = {
    user    => $user,
    app     => $name,
    command => $command,
  }

  $launchers = {
    "${name}-celery-beat" => merge($launcher_props, $launcher_overrides)
  }

  create_resources(django::launcher, $launchers)


}

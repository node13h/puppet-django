define django::app (
  $user,
  $group,
  $wsgi_module                 = "${name}.wsgi",
  $bind                        = '127.0.0.1:8080',
  $num_workers                 =  $::processorcount * 2 + 1,
  $log_level                   = 'info',

  $wsgi_server                 = 'gunicorn',  # 'gunicorn' or 'custom'
  $custom_command              = 'fab start',

  $generate_launcher           = true,
  $launcher_overrides          = {},

) {

  include '::django'

  validate_string($wsgi_module)
  validate_string($bind)
  validate_string($log_level)

  if $wsgi_server == 'custom' {
    validate_string($custom_command)
  }

  validate_bool($generate_launcher)
  if $generate_launcher {
    validate_hash($launcher_overrides)
  }

  case $wsgi_server {
    'gunicorn': { $command = "gunicorn ${wsgi_module} --name=\"${name}\" --workers=${num_workers} --user=${user} --group=${group} --bind=${bind} --log-level=${log_level} --log-file=-" }
    'custom': { $command = $custom_command }
    default: { fail("Unsupported WSGI server (${wsgi_server})") }
  }

  if $generate_launcher {

    $launcher_props = {
      user    => $user,
      app     => $name,
      command => $command,
    }

    $launchers = {
      "${name}-django-app" => merge($launcher_props, $launcher_overrides)
    }

    create_resources(django::launcher, $launchers)
  }
}

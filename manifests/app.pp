define django::app (
  $user,
  $group,
  $appdir                      = undef,
  $srcdir                      = undef,
  $virtualenv                  = undef,
  $settings_module             = "${name}.settings",
  $wsgi_module                 = "${name}.wsgi",
  $launcher                    = "/usr/local/bin/launch-${name}-django-app.sh",
  $generate_launcher           = true,

  $bind                        = '127.0.0.1:8080',
  $num_workers                 =  $::processorcount * 2 + 1,
  $log_level                   = 'info',

  $wsgi_server                 = 'gunicorn',  # 'gunicorn' or 'custom'
  $custom_command              = 'fab start',

  $generate_supervisord_config = true,
  $supervisord_config          = "$::django::supervisord::confdir/${name}-django-app.conf",
  
) {

  include '::django'

  validate_string($user)
  validate_string($group)

  if $appdir == undef {
    $_appdir = "/home/${user}/Sites/${name}"
  } else {
    $_appdir = $appdir
  }
  validate_absolute_path($_appdir)

  if $srcdir == undef {
    $_srcdir = "${_appdir}/base"
  } else {
    $_srcdir = $srcdir
  }
  validate_absolute_path($_srcdir)

  if $virtualenv == undef {
    $_virtualenv = "${_appdir}/venv"
  } else {
    $_virtualenv = $virtualenv
  }
  validate_absolute_path($_virtualenv)

  validate_string($settings_module)
  validate_string($wsgi_module)

  validate_absolute_path($launcher)
  validate_bool($generate_launcher)

  validate_string($bind)

  validate_string($log_level)

  if $wsgi_server == 'custom' {
    validate_string($custom_command)
  }

  case $wsgi_server {
    'gunicorn': { $command = "gunicorn ${wsgi_module} --name=\"${name}\" --workers=${num_workers} --user=${user} --group=${group} --bind=${bind} --log-level=${log_level} --log-file=-" }
    'custom': { $command = $custom_command }
    default: { fail("Unsupported WSGI server (${wsgi_server})") }
  }
  
  if $generate_launcher {

    file { $launcher:
      ensure  => present,
      mode    => 0755,
      owner   => 'root',
      content => template('django/launcher.erb')
    }

  }

  if $generate_supervisord_config {

    file { $supervisord_config:
      ensure  => present,
      content => template('django/supervisord.erb'),
      require => Package[$::django::supervisord::package_name],
      notify  => Service[$::django::supervisord::service_name],
    }

  }

}

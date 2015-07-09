define django::launcher (
  $user,
  $app,
  $command,
  $appdir                      = undef,
  $srcdir                      = undef,
  $virtualenv                  = undef,
  $settings_module             = undef,
  $path                        = "/usr/local/bin/launch-${name}.sh",

  $generate_supervisord_config = true,
  $supervisord_config          = "$::django::supervisord::confdir/${name}.conf",

) {

  include '::django'

  validate_string($user)
  validate_string($app)

  if $appdir == undef {
    $_appdir = "/home/${user}/Sites/${app}"
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

  if $settings_module == undef {
    $_settings_module = "${app}.settings"
  } else {
    $_settings_module = $settings_module
  }
  validate_string($_settings_module)

  validate_absolute_path($path)

  file { $path:
    ensure  => present,
    mode    => 0755,
    owner   => 'root',
    content => template('django/launcher.erb'),
    notify  => Service[$::django::supervisord::service_name],
  }


  if $generate_supervisord_config {

    file { $supervisord_config:
      ensure  => present,
      content => template('django/supervisord.erb'),
      notify  => Service[$::django::supervisord::service_name],
    }

  }
}

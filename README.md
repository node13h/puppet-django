# Django module for Puppet
Manages deployed Django apps and related stuff

## Features
* Supports multiple Django applications on the same server
* Manages application processes with Supervisord
* Supports per-app virtualenvs
* Installs application-related OS packages
* Manages user accounts and deployment ssh keys
* Manages Celery workers and beat
* Supports environment variable definition from .env file placed in srcdir (like Heroku Foreman)
* ENC-friendly
* Sane defaults which can be overriden

## Usage

* Application code by default is expected at /home/_username_/Sites/_appname_/base (customizable)
* virtualenv by default is expected at /home/_username_/Sites/_appname_/venv (customizable)
* for apps - gunicorn package is expected in virtualenv (add to your requirements.txt)
* setproctitle package is optional in virtualenv
* apps, workers and beats may reside on different nodes

```puppet

  class { '::django':
    apps    => {
      polls => {
        user  => 'bob',
      },
    },
```

### More complex example

```puppet

  class { '::django':
    apps    => {
      polls => {
        user  => 'bob',
        bind  => '127.0.0.1:8000',
      },
    },
    workers => {
      worker1 => {
        user => 'bob',
        app  => 'polls',
      },
    },
    beats    => {
      polls => {
        user             => 'bob',
        schedule_db_file => '/home/users/bob/Sites/polls/run/beat-schedule',
        pidfile          => '/home/users/bob/Sites/polls/run/celerybeat.pid',
      },
    },
    packages => [
      'python-pip',
      'python-virtualenv',
      'libpq-dev',
      'python-dev',
      'git',
      'libwebp-dev',
      'liblcms2-dev',
      'libtiff5-dev',
      'libfreetype6-dev',
      'zlib1g-dev',
      'liblcms1-dev',
    ],
    users     => {
      bob => {
        comment => 'Polls app server user',
        home    => '/home/bob',
      },
    },
    keys      => {
      'developer-john-pubkey' => {
        key  => 'pubkey-pubkey-pubkey-pubkey-pubkey-pubkey-pubkey-pubkey-pubkey-pubkey',
        user => 'bob',
      },
      'developer-alice-pubkey' => {
        key  => 'pubkey-pubkey-pubkey-pubkey-pubkey-pubkey-pubkey-pubkey-pubkey-pubkey',
        user => 'bob',
      },
    },
  }

```

### Defaults can be overriden

```puppet

  class { '::django':
    apps    => {
      testapp => {
        user               => 'jack',
        bind               => '127.0.0.1:8000',
        launcher_overrides => {
          srcdir          => '/srv/apps/testapp',
          virtualenv      => '/home/jack/.virtualenvs/testenv',
          settings_module => 'testapp.local_settings',
        },
      },
    },
  }

```

### Suggested workflow

* Declare django class in node definition
* After puppet sets up users, keys and directories - create virtualenv in
  expected directory and deploy code in srcdir (see above example)

### Multiple apps and multiple users are supported

```puppet

  class { '::django':
    apps    => {
      app1 => {
        user        => 'bob',
        bind        => '127.0.0.1:8000',
        num_workers => 1,
      },
      app2 => {
        user           => 'bob',
        bind           => '127.0.0.1:8001',
        wsgi_server    => 'custom',
        custom_command => 'fab runmyserver',
        log_level      => 'debug',
      },
      app3 => {
        user  => 'jack',
        bind  => '127.0.0.1:8002',
      },
      app4 => {
        user  => 'alreadyexistinguser',
        bind  => '127.0.0.1:8003',
      },
    },
    users     => {
      bob => {
        comment => 'app1 and app2 server user',
        home    => '/home/bob',
      },
      jack => {
        comment => 'app3 server user',
        home    => '/home/jack',
      },
    },
  }

```
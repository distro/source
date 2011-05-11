Package.define('bitlbee') {
  use Misc::Administration

  tags 'application', 'network', 'im', 'irc'

  description 'irc to IM gateway that support multiple IM protocols'
  homepage    'http://www.bitlbee.org'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://get.bitlbee.org/src/bitlbee-#{package.version}.tar.gz'

  flavor {
    documentation {
      after :install do |conf|
        package.autotools.make 'install-doc', "DESTDIR=#{package.distdir}" if enabled?
      end
    }

    headers {
      after :install do |conf|
        package.autotools.make 'install-dev', "DESTDIR=#{package.distdir}" if enabled?
      end
    }
  }

  features {
    ipv6 {
      before :configure do |conf|
        conf.set 'ipv6', (enabled? ? 1 : 0)
      end
    }

    ssl {
      needs '!(gnutls || nss)'

      before :configure do |conf|
        conf.set 'ssl', 'openssl' if enabled?
      end
    }

    gnutls {
      needs '!(ssl || nss)'

      before :configure do |conf|
        conf.set 'ssl', 'gnutls' if enabled?
      end
    }

    nss {
      needs '!(gnutls || ssl)'

      before :configure do |conf|
        conf.set 'ssl', 'nss' if enabled?
      end
    }

    msn {
      needs 'ssl || gnutls || nss'

      before :configure do |conf|
        conf.set 'msn', (enabled? ? 1 : 0)
      end
    }

    jabber {
      needs '!nss'

      before :configure do |conf|
        conf.set 'jabber', (enabled? ? 1 : 0)

        if !features.ssl? && !features.gnutls?
          CLI.warn %{
            You have enabled support for Jabber but do not have SSL
            support enabled. This *will* prevent bitlbee from being
            able to connect to SSL enabled Jabber servers. If you need to
            connect to Jabber over SSL, enable ONE of the following
            features: gnutls or ssl
          }
        end
      end
    }

    oscar {
      before :configure do |conf|
        conf.set 'oscar', (enabled? ? 1 : 0)
      end
    }

    purple {
      before :configure do |conf|
        conf.set 'purple', (enabled? ? 1 : 0)
      end
    }

    yahoo {
      before :configure do |conf|
        conf.set 'yahoo', (enabled? ? 1 : 0)
      end
    }

    twitter {
      before :configure do |conf|
        conf.set 'twitter', (enabled? ? 1 : 0)
      end
    }

    plugins { enabled!
      before :configure do |conf|
        conf.set 'plugins', (enabled? ? 1 : 0)
      end
    }

    otr {
      needs 'plugins'

      before :configure do |conf|
        conf.set 'otr', 'plugin' if enabled?
      end
    }

    libevent {
      before :dependencies do |deps|
        deps << (enabled? ?
          'library/network/libevent' :
          '>=library/glib-2.4')
      end

      before :configure do |conf|
        conf.set 'events', (enabled? ? 'libevent' : 'glib')
      end
    }
  }

  autotools.force!

  before :configure, priority: -10 do |conf|
    conf.clear

    if !features.ssl? && !features.gnutls? && !features.nss?
      conf.set 'ssl', 'bogus'
    end

    conf.set 'ldap', 0
    conf.set 'strip', 0

    conf.set 'prefix',    Path.clean(env[:INSTALL_PATH] + '/usr')
    conf.set 'datadir',   Path.clean(env[:INSTALL_PATH] + '/usr/share/bitlbee')
    conf.set 'etcdir',    Path.clean(env[:INSTALL_PATH] + '/etc/bitlbee')
    conf.set 'plugindir', Path.clean(env[:INSTALL_PATH] + '/usr/lib/bitlbe')
  end

  after :configure do |conf|
    Do.sed 'Makefile.settings',
      [/CFLAGS=.*$/, '']
		  [/^(EFLAGS=)/, '\1${LDFLAGS}']
  end

  after :install do |conf|
    package.autotools.make 'install-etc', "DESTDIR=#{package.distdir}"
  end

  admin.do {
    useradd :bitlbee, home: Path.clean(package.env[:INSTALL_PATH] + '/var/lib/bitlbee')

    chown Path.clean(package.env[:INSTALL_PATH] + '/var/lib/bilbee'), user: :bitlbee, group: :bitlbee
    chown Path.clean(package.env[:INSTALL_PATH] + '/var/run/bilbee'), user: :bitlbee, group: :bitlbee
  }
}

# Maintainer: meh. <meh@paranoici.org>

require 'packo/behaviors/gnu'

Packo::Package.new('development/interpreters/ruby') {
  behavior Packo::Behaviors::GNU

  description 'Fluxbox is an X11 window manager featuring tabs and an iconbar'
  homepage    'http://www.fluxbox.org'
  license     'MIT'

  source 'ftp://ftp.ruby-lang.org/pub/ruby/#{package.version.major}.#{package.version.minor}/ruby-#{package.version}.tar.gz'

  dependencies << 'system/libraries/zlib' << 'development/libraries/libffi'

  flavors {
    debug {
      on :configure do |conf|
        conf.enable 'debug', enabled?
      end
    }

    documentation {
      on :configure do |conf|
        conf.enable 'install-doc', enabled?
      end
    }
  }

  features {
    ipv6 {
      on :configure do |conf|
        conf.enable 'ipv6', enabled?
        conf.with 'look-up-order-hack', 'INET' if enabled?
      end
    }

    berkdb {
      on :dependencies do |package|
        package.dependencies << 'system/libraries/db' if enabled?
      end

      on :configure do |conf|
        conf.with 'dbm', enabled?
      end
    }

    gdbm {
      on :dependencies do |package|
        package.dependencies << 'system/libraries/gdbm' if enabled?
      end

      on :configure do |conf|
        conf.with 'gdbm', enabled?
      end
    }

    ssl {
      on :dependencies do |package|
        package.dependencies << 'development/libraries/openssl' if enabled?
      end

      on :configure do |conf|
        conf.with 'openssl', enabled?
      end
    }

    socks5 {
      on :dependencies do |package|
        package.dependencies << '>=network/proxies/dante-1.1.13' if enabled?
      end

      on :configure do |conf|
        conf.enable 'socks', enabled?
      end
    }

    tk {
      on :dependencies do |package|
        package.dependencies << 'development/interpreters/tk[threads]' if enabled?
      end

      on :configure do |conf|
        conf.with 'tk', enabled?
      end
    }

    ncurses {
      on :dependencies do |package|
        package.dependencies << 'system/libraries/ncurses' if enabled?
      end

      on :configure do |conf|
        conf.with 'curses', enabled?
      end
    }

    libedit {
      on :dependencies do |package|
        package.dependencies << 'development/libraries/libedit' if enabled?
      end

      on :configure do |conf|
        conf.enable 'libedit' if enabled?
      end
    }

    self.set('readline') { enabled!
      on :dependencies do |package|
        package.dependencies << 'system/libraries/readline' if enabled? && !package.features.libedit.enabled?
      end
    }
  }

  on :configure, -10 do |conf|
    autotools.autoreconf

    if package.features.readline.enabled? || package.features.libedit.enabled?
      conf.with 'readline'
    else
      conf.without 'readline'
    end

    conf.set 'program-suffix', package.slot
    conf.with 'soname', package.slot

    conf.enable ['shared', 'pthread']
    conf.enable 'option-checking', 'no'
  end

  on :compile do
    ENV['EXTLDFLAGS'] = ENV['LDFLAGS']
  end
}

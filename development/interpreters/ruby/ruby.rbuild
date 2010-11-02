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
  }

  features {
    ipv6 {
      on :configure do |conf|
        conf.enable 'ipv6', enabled?
      end
    }

    berkdb {
      on :dependencies do |package|
        package.dependencies << 'system/libraries/db' if enabled?
      end
    }

    gdbm {
      on :dependencies do |package|
        package.dependencies << 'system/libraries/gdbm' if enabled?
      end
    }

    ssl {
      on :dependencies do |package|
        package.dependencies << 'development/libraries/openssl' if enabled?
      end
    }

    socks5 {
      on :dependencies do |package|
        package.dependencies << '>=network/proxies/dante-1.1.13' if enabled?
      end
    }

    tk {
      on :dependencies do |package|
        package.dependencies << 'development/interpreters/tk[threads]' if enabled?
      end
    }

    ncurses {
      on :dependencies do |package|
        package.dependencies << 'system/libraries/ncurses' if enabled?
      end
    }

    libedit {
      on :dependencies do |package|
        package.dependencies << 'development/libraries/libedit' if enabled?
      end
    }

    self.set 'readline' {
      on :dependencies do |package|
        package.dependencies << 'system/libraries/readline' if enabled? && !package.features.libedit.enabled?
      end
    }
  }

  on :configure, -10 do |conf|
    Packo.sh 'autoconf'

    conf.set 'program-suffix', package.slot
    conf.with 'soname', package.slot

    conf.enable ['shared', 'pthread']
  end

  on :unpacked, 10 do
    Dir.chdir "#{package.workdir}/ruby-#{package.version}"
  end
}

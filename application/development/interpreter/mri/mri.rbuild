Package.define('mri') {
  tags 'application', 'interpreter', 'development', 'ruby'

  description 'An object-oriented scripting language'
  homepage    'http://www.ruby-lang.org/'
  license     'MIT'

  maintainer 'meh. <meh@paranoici.org>'

  source 'ftp://ftp.ruby-lang.org/pub/ruby/#{version.major}.#{version.minor}/ruby-#{version}.tar.gz'

  dependencies << 'system/library/zlib' << 'development/library/libffi'

  flavors {
    debug {
      before :configure do |conf|
        conf.enable 'debug', enabled?
      end
    }

    documentation {
      before :configure do |conf|
        conf.enable 'install-doc', enabled?
      end
    }
  }

  features {
    ipv6 {
      before :configure do |conf|
        conf.enable 'ipv6', enabled?
        conf.with 'look-up-order-hack', 'INET' if enabled?
      end
    }

    berkdb {
      before :configure do |conf|
        conf.with 'dbm', enabled?
      end
    }

    gdbm {
      before :configure do |conf|
        conf.with 'gdbm', enabled?
      end
    }

    ssl {
      before :dependencies do |deps|
        deps << 'development/library/openssl' if enabled?
      end

      before :configure do |conf|
        conf.with 'openssl', enabled?
      end
    }

    socks5 {
      before :dependencies do |deps|
        deps << '>=network/proxy/dante-1.1.13' if enabled?
      end

      before :configure do |conf|
        conf.enable 'socks', enabled?
      end
    }

    tk {
      before :dependencies do |deps|
        deps << 'development/interpreter/tk[threads]' if enabled?
      end

      before :configure do |conf|
        conf.with 'tk', enabled?
      end
    }

    ncurses {
      before :dependencies do |deps|
        deps << 'system/library/text/ncurses' if enabled?
      end

      before :configure do |conf|
        conf.with 'curses', enabled?
      end
    }

    libedit {
      before :dependencies do |deps|
        deps << 'development/library/text/edit' if enabled?
      end

      before :configure do |conf|
        conf.enable 'libedit' if enabled?
      end
    }

    self.set('readline') { enabled!
      before :dependencies do |deps|
        deps << 'system/library/text/readline' if enabled? && !package.features.libedit.enabled?
      end
    }
  }

  after :unpack do
    Do.cd("#{workdir}/ruby-#{version}")
  end

  before :configure, :priority => -10 do |conf|
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

  before :compile do
    ENV['EXTLDFLAGS'] = ENV['LDFLAGS']
  end
}

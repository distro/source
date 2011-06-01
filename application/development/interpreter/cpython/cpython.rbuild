Package.define('cpython') {
  tags 'application', 'interpreter', 'development', 'python'

  description 'An interpreted, interactive, object-oriented programming language.'
  homepage    'http://www.python.org/'
  license     'PSF-2.2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://www.python.org/ftp/python/#{version}/Python-#{version}.tar.bz2'

  dependencies << 'system/library/zlib' << 'development/library/libffi'

  features {
    threads {
      before :configure do |conf|
        conf.with 'threads', enabled?
      end
    }

    ipv6 {
      before :configure do |conf|
        conf.enable 'ipv6', enabled?
      end
    }

    ssl {
      before :configure do |conf|
        env[:PYTHON_DISABLE_SSL] = 1
      end
    }

    ncurses {
      before :configure do |conf|
        package.disable << '_curses' << '_curses_panel' if disabled?
      end
    }

    self.set('readline') {
      before :configure do |conf|
        package.disable << 'readline' if disabled?
      end
    }

    xml {
      before :configure do |conf|
        if disabled?
          package.disable << 'pyexpat'

          CLI.warn %{
            You have configured Python without XML support.
            This is NOT a recommended configuration as you
            may face problems parsing any XML documents.
          }
        end
      end
    }

    berkdb {
      before :configure do |conf|
        package.disable << '_bsddb' if disabled?
      end
    }

    gdbm {
      before :configure do |conf|
        package.disable << 'gdbm' if disabled?
      end
    }

    tk {
       before :configure do |conf|
        package.disable << '_tkinter' if disabled?
      end
    }
  }

  before :initialize do
    package.disable = []
  end

  after :unpack do
    Do.cd "Python-#{package.version}"

    Do.rm :rf, 'Modules/expat', 'Modules/_ctypes/libffi*', 'Modules/zlib'

    Do.sed 'Makefile.pre.in', ['@OPT@', "#{package.env[:CFLAGS]} #{'-DNDEBUG' unless flavor.debug?}"]
  end

  before :configure, priority: 10 do |conf|
    if features.gdbm.disabled? && features.berkdb.disabled?
      package.disable << 'dbm'
    end

    env[:PYTHON_DISABLE_MODULES] = package.disable.join(' ')

    CLI.info "Disabled modules: #{env[:PYTHON_DISABLE_MODULES]}"

    conf.enable ['shared']
    conf.with   ['fpectl']

    conf.enable 'unicode', 'ucs4'
    conf.with   'libc', ''

    if version >= '2.7'
      conf.enable ['loadable-sqlite-extensions']
      conf.with   ['system-expat', 'syste-ffi']
    end

    if version >= '3'
      conf.with ['computed-gotos']
    end

    autotools.autoreconf
  end

  after :install do
    package.do.rm '/usr/bin/python'
  end
}

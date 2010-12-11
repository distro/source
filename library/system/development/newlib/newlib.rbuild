Package.define('newlib') { type 'libc'
  tags 'library', 'system', 'libc'

  description 'Newlib is a C library intended for use on embedded systems'
  homepage    'http://sourceware.org/newlib/'
  license     'NEWLIB', 'LIBGLOSS', 'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'ftp://sources.redhat.com/pub/newlib/newlib-#{package.version}.tar.gz'

  features {
    unicode { enabled!
      before :configure do |conf|
        conf.enable 'newlib-mb', enabled?
      end
    }

    nls {
      before :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    threads { enabled!
      before :configure do |conf|
        conf.enable 'newlib-multithreaded', enabled?
      end
    }
  }

  before :configure do |conf|
    environment[:CXXFLAGS] = environment[:CFLAGS] = '-O2 -pipe'
    environment[:LDFLAGS]  = ''

    Do.dir "#{workdir}/build"
    Do.cd  "#{workdir}/build"

    conf.path = "#{workdir}/newlib-#{version}/configure"
    
    conf.enable ['newlib-hw-fp', 'shared', 'static']
  end

  before :compile do
    package.autotools.make '-j1'

    throw :halt
  end
}

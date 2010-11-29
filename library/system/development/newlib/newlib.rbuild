Package.define('newlib') { type 'libc'
  behavior Behaviors::GNU

  maintainer 'meh. <meh@paranoici.org>'

  tags 'library', 'system', 'libc'

  description 'Newlib is a C library intended for use on embedded systems'
  homepage    'http://sourceware.org/newlib/'
  license     'NEWLIB', 'LIBGLOSS', 'GPL-2'


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
    environment[:LDFLAGS] = ''
    
    conf.enable ['newlib-hw-fp', 'shared', 'static']
  end
}

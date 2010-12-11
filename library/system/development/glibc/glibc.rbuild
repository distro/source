Package.define('glibc') { type 'libc'
  tags 'library', 'system', 'libc', 'gnu'

  description 'GNU libc6 (also called glibc2) C library'
  homepage    'http://www.gnu.org/software/libc/libc.html'
  license     'LGPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'gnu://glibc/#{package.version}'

  flavor {
    hardened {
      before :configure do |conf|
        conf.enable 'stackguard-randomization', enabled?
      end
    }
  }

  features {
    nls {
      before :configura do |conf|
        conf.disale 'nls' if disabled?
      end
    }
  }

  before :initialize do
    package.environment[:CXXFLAGS] = package.environment[:CFLAGS] = '-O2 -fno-strict-aliasing -pipe'
    package.environment[:LDFLAGS]  = ''
  end

  before :configure do |conf|
    Do.dir "#{package.workdir}/build"
    Do.cd  "#{package.workdir}/build"

    conf.path = "#{package.workdir}/glibc-#{package.version}/configure"

    conf.without ['cvs', 'gd']
    conf.enable  ['bind-now']
  end

  before :compile do
    package.autotools.make '-j1'

    throw :halt
  end
}

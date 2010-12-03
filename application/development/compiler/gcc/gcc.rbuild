Package.define('gcc') { type 'compiler'
  behavior Behaviors::GNU
  use      Modules::Fetching::GNU

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'compiler', 'system', 'development'

  description 'The GNU Compiler Collection'
  homepage    'http://gcc.gnu.org/'
  license     'GPL-3', 'LGPL-3'

  source 'gcc/#{package.version}'

  features {
    ada {
      before :build do |pkg|
        pkg.languages << 'ada' if enabled?
      end
    }

    java {
      before :build do |pkg|
        pkg.languages << 'java' if enabled?
      end
    }
    
    fortran {
      before :build do |pkg|
        pkg.languages << 'fortran' if enabled?
      end
    }

    objc {
      before :build do |pkg|
        pkg.languages << 'objc' if enabled?
      end
    }

    objcxx {
      before :build do |pkg|
        pkg.languages << 'objcp' if enabled?
      end
    }

    optimizations { enabled!
      before :configure do |conf|
        conf.enable('altivec', enabled? && ['ppc', '~ppc'].member?(package.environment[:ARCH]))
        conf.enable('fixed-point', enabled? && ['mips', '~mips'].member?(package.environment[:ARCH]))
      end
    }

    multilib {

    }

    nls {
      before :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    openmp {

    }
  }

  selector [{
    :name        => 'gcc',
    :description => 'Set the gcc version to use',

    :path => '#{package.path}/files/select-gcc.rb'
  }]

  before :initialize, -10 do |pkg|
    pkg.languages = ['c', 'c++']
  end

  before :configure do |conf|
    Do.dir './build'
    Do.cd  './build'

    conf.path = '../configure'

    conf.set 'bindir',     "/usr/#{package.target}/gcc-bin/#{package.version}"
    conf.set 'libdir',     "/usr/lib/gcc/#{package.target}/#{package.version}"
    conf.set 'libexecdir', "/usr/lib/gcc/#{package.target}/#{package.version}"
    conf.set 'includedir', "/usr/lib/gcc/#{package.target}/#{package.version}/include"
    conf.set 'datadir',    "/usr/share/gcc-data/#{package.target}/#{package.version}"
    conf.set 'infodir',    "/usr/share/gcc-data/#{package.target}/#{package.version}/info"
    conf.set 'mandir',     "/usr/share/gcc-data/#{package.target}/#{package.version}/man"

    conf.with 'gxx-include-dir', "/usr/lib/gcc/#{package.target}/#{package.version}/include/g++v4"
    conf.with 'python-dir',      "/usr/share/gcc-data/#{package.target}/#{package.version}/python"

    if Environment[:CROSS]
      conf.set 'bindir', "/usr/#{package.host}/#{package.target}/gcc-bin/#{package.version}"    
    end

    conf.enable  ['secureplt']
    conf.disable ['werror', 'libmudflap', 'libssp', 'libgomp', 'shared', 'bootstrap']
    conf.with    ['system-zlib']
    conf.without ['ppl', 'cloog', 'included-gettext']

    # c, c++, fortran, ada, java, objc, objcp
    conf.enable 'languages', package.languages.join(',')

    conf.enable 'checking', 'release'
    conf.with   'pkgversion', "Distrø #{package.version}"

    conf.with 'arch', package.target.arch
  end

  before :pack do
    package.slot = "#{package.slot}-#{environment[:ARCH]}-#{environment[:KERNEL]}"
  end
}

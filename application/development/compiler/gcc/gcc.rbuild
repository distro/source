Package.define('gcc') {
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
    conf.set  'prefix', "/usr/compilers/gcc/#{package.version}"
    conf.with 'gxx-include-dir', "/usr/compilers/gcc/#{package.version}/include/g++-v4"
    conf.with 'python-dir', "/usr/compilers/gcc/#{package.version}/python"

    conf.with    ['system-zlib']
    conf.without ['ppl', 'cloog', 'included-gettext']
    conf.enable  ['libmudflap', 'secureplt', 'libgomp', 'shared', '__cxa_atexit']

    conf.enable 'clocale', 'gnu'
    conf.enable 'checking', 'release'
    conf.enable 'threads', 'posix'

    # c, c++, fortran, ada, java, objc, objcp
    conf.enable 'languages', package.languages.join(',')

    conf.with 'pkgversion', "Distrø #{package.version}"
  end
}

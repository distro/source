# Maintainer: meh. <meh@paranoici.org>

require 'packo/behaviors/gnu'
require 'packo/modules/fetching/gnu'

Packo::Package.new('system/development/gcc') {
  behavior Packo::Behaviors::GNU
  use      Packo::Modules::Fetching::GNU

  description 'The GNU Compiler Collection'
  homepage    'http://gcc.gnu.org/'
  license     'GPL-3', 'LGPL-3'

  source 'gcc/#{package.version}'

  features {
    ada {
      on :initialize do |package|
        package.languages << 'ada' if enabled?
      end
    }

    java {
      on :initialize do |package|
        package.languages << 'java' if enabled?
      end
    }
    
    fortran {
      on :initialize do |package|
        package.languages << 'fortran' if enabled?
      end
    }

    objc {
      on :initialize do |package|
        package.languages << 'objc' if enabled?
      end
    }

    objcxx {
      on :initialize do |package|
        package.languages << 'objcp' if enabled?
      end
    }

    optimizations { enabled!
      on :configure do |conf|
        conf.enable('altivec', enabled? && ['ppc', '~ppc'].member?(package.environment[:ARCH]))
        conf.enable('fixed-point', enabled? && ['mips', '~mips'].member?(package.environment[:ARCH]))
      end
    }

    multilib {

    }

    nls {
      on :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    openmp {

    }
  }

  on :initialize, -10 do |package|
    package.languages = ['c', 'c++']
  end

  on :configure do |conf|
    conf.set 'prefix', "#{package.distdir}/usr/compilers/gcc/#{package.version}"
    conf.with 'gxx-include-dir', "#{package.distdir}/usr/compilers/gcc/#{package.version}/include/g++-v4"
    conf.with 'python-dir', "#{package.distdir}/usr/compilers/gcc/#{package.version}/python"

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

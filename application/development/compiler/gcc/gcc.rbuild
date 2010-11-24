# Maintainer: meh. <meh@paranoici.org>

Package.define(['system', 'development', 'application'], 'gcc') {
  behavior Behaviors::GNU
  use      Modules::Fetching::GNU

  description 'The GNU Compiler Collection'
  homepage    'http://gcc.gnu.org/'
  license     'GPL-3', 'LGPL-3'

  source 'gcc/#{package.version}'

  features {
    ada {
      on :build do |package|
        package.languages << 'ada' if enabled?
      end
    }

    java {
      on :build do |package|
        package.languages << 'java' if enabled?
      end
    }
    
    fortran {
      on :build do |package|
        package.languages << 'fortran' if enabled?
      end
    }

    objc {
      on :build do |package|
        package.languages << 'objc' if enabled?
      end
    }

    objcxx {
      on :build do |package|
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

  selector [{
    :name        => 'gcc',
    :description => 'Set the gcc version to use',

    :path => '#{package.path}/files/select-gcc.rb'
  }]

  on :initialize, -10 do |package|
    package.languages = ['c', 'c++']
  end

  on :configure do |conf|
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

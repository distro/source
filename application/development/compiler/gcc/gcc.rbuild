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
    multilib {
      before :configure do |conf|
        conf.disable 'multilib' unless enabled?
      end
    }

    ada {
      before :build do |pkg|
        pkg.languages << 'ada' if enabled?
      end
    }

    cxx { enabled!
      before :build do |pkg|
        pkg.languages << 'c++' if enabled?
      end
    }

    fortran {
      before :build do |pkg|
        pkg.languages << 'fortran' if enabled?
      end
    }

    java {
      before :build do |pkg|
        pkg.languages << 'java' if enabled?
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

    nls {
      before :configure do |conf|
        if enabled?
          conf.enable 'nls'
          conf.disable 'included-gettext'
        else
          conf.disable 'nls'
        end
      end
    }

    openmp {

    }
  }

  after :initialize do
    package.languages = ['c']
  end

  before :dependencies do |deps|
    if target.kernel == 'cygwin'
      if host != target
        deps << "library/system/development/cygwin%#{target}!"
      else
        deps << 'library/system/development/cygwin!'
      end
    end
  end

  before :configure do |conf|
    conf.with 'sysroot', "/usr/#{host}/#{target}"

    environment[:CPP] = "cpp --sysroot /usr/#{host}/#{target}"
    environment[:CXXFLAGS] = environment[:CFLAGS] = '-O2 -pipe'
    environment[:LDFLAGS]  = ''

    Do.dir "#{workdir}/build"
    Do.cd  "#{workdir}/build"

    conf.path = "#{workdir}/gcc-#{version}/configure"

    middle = (host != target) ? "#{host}/#{target}" : "#{target}"

    conf.set 'bindir',     "/usr/#{middle}/gcc-bin/#{version}"
    conf.set 'libdir',     "/usr/lib/gcc/#{middle}/#{version}"
    conf.set 'libexecdir', "/usr/lib/gcc/#{middle}/#{version}"
    conf.set 'includedir', "/usr/lib/gcc/#{middle}/#{version}/include"
    conf.set 'datadir',    "/usr/share/gcc-data/#{middle}/#{version}"
    conf.set 'infodir',    "/usr/share/gcc-data/#{middle}/#{package.version}/info"
    conf.set 'mandir',     "/usr/share/gcc-data/#{middle}/#{package.version}/man"

    conf.with 'gxx-include-dir', "/usr/lib/gcc/#{middle}/#{version}/include/g++v4"
    conf.with 'python-dir',      "/usr/share/gcc-data/#{middle}/#{version}/python"

    conf.with 'as', "/usr/bin/#{target}-as"
    conf.with 'ld', "/usr/bin/#{target}-ld"

    conf.enable  ['secureplt']
    conf.disable ['werror', 'libmudflap', 'libssp', 'libgomp', 'shared', 'bootstrap']
    conf.with    ['system-zlib']
    conf.without ['ppl', 'cloog']

    # c, c++, fortran, ada, java, objc, objcp
    conf.enable 'languages', package.languages.join(',')

    conf.enable 'checking',   'release'
    conf.with   'pkgversion', "Distrø #{version}"

    # Various conditional configurations

    if host.kernel == 'cygwin'
      conf.enable 'threads', 'win32'
    else
      conf.enable 'threads', 'posix'
    end

    if target.kernel == 'darwin'
      conf.enable 'version-specific-runtime-libs'
    end

    if target.kernel == 'freebsd' || target.misc == 'gnu' || target.kernel == 'solaris'
      conf.enable '__cxa_atexit'
    else
      conf.disable '__cxa_atexit'
    end

    if target.misc == 'gnu'
      conf.enable 'clocale', 'gnu'
    end

    if environment[:LIBC] == 'newlib'
      conf.with 'newlib'
    end
  end

  before :compile do
    autotools.make '-j1'

    throw :halt
  end
}

__END__
$$$

$$$ selectors/select-gcc.rb $$$

#! /usr/bin/env ruby
require 'optitron'

require 'packo'
require 'packo/binary/helpers'

class Application < Optitron::CLI
  include Packo
  include Binary::Helpers
  include Models

  desc 'List available gcc versions'
  def list
    info 'List of availaibale gcc versions'

    current = self.current

    self.versions.each {|target, versions|
      next if versions.empty?

      puts ''
      puts colorize(target, :BLUE, :DEFAULT, :BOLD)

      versions.each_with_index {|version, i|
        puts (current[target] == version) ?
          "  {#{colorize(i + 1, :GREEN)}}    #{version}" :
          "  [#{i + 1}]    #{version}"
      }
    }
  end

  desc 'Choose what version of gcc to use'
  def set (version, target=Packo::Host.to_s)
    versions = self.versions[target]

    if version.numeric? && (version.to_i > versions.length || version.to_i < 1)
      fatal "#{version} out of index"
      exit 1
    end

    if version.numeric?
      version = versions[version.to_i - 1]
    end

    if !versions.member? version
      fatal "#{version} version not available for #{target}"
      exit 2
    end

    if target == Packo::Host.to_s
      FileUtils.ln_sf Dir.glob("/usr/#{Packo::Host}/gcc-bin/#{version}/*"), '/usr/bin'
    else
      FileUtils.ln_sf Dir.glob("/usr/#{Packo::Host}/#{target}/gcc-bin/#{version}/#{target}-*"), '/usr/bin/'
    end

    info "Set gcc to #{version} for #{target}"

    Selector.first(:name => 'gcc').update(:data => self.current.merge(target => version))
  end

  def current
    (Selector.first(:name => 'gcc').data rescue nil) || {}
  end

  def versions
    versions = Dir.glob("/usr/#{Packo::Host}/*").select {|target|
      Host.parse(target.sub("/usr/#{Packo::Host}/", '')) && !target.end_with?('-bin')
    }.map {|target|
      [target.sub("/usr/#{Packo::Host}/", ''), Dir.glob("#{target}/gcc-bin/*").map {|version|
        Versionomy.parse(version.sub("#{target}/gcc-bin/", ''))
      }]
    }

    versions << [Packo::Host.to_s, Dir.glob("/usr/#{Packo::Host}/gcc-bin/*").map {|version|
      Versionomy.parse(version.sub("/usr/#{Packo::Host}/gcc-bin/", ''))
    }]

    Hash[versions]
  end
end

Application.dispatch

# gcc: Set the gcc version to use

$$$ patches/libstdc++-v3/crossconfig.path $$$

--- crossconfig.m4.orig	2010-12-07 02:47:04.951291393 +0000
+++ crossconfig.m4	2010-12-07 02:48:51.926279025 +0000
@@ -193,7 +193,7 @@
 	;;
     esac
     ;;
-  *-linux* | *-uclinux* | *-gnu* | *-kfreebsd*-gnu | *-knetbsd*-gnu)
+  *-linux* | *-uclinux* | *-gnu* | *-kfreebsd*-gnu | *-knetbsd*-gnu | *-cygwin*)
     AC_CHECK_HEADERS([nan.h ieeefp.h endian.h sys/isa_defs.h \
       machine/endian.h machine/param.h sys/machine.h sys/types.h \
       fp.h float.h endian.h inttypes.h locale.h float.h stdint.h \

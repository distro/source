Package.define('gcc') { type 'compiler'
  tags 'application', 'compiler', 'system', 'development', 'gnu'

  description 'The GNU Compiler Collection'
  homepage    'http://gcc.gnu.org/'
  license     'GPL-3', 'LGPL-3'

  maintainer 'meh. <meh@paranoici.org>'

  source 'gnu://gcc/#{package.version}'

  flavor {
    multilib {
      before :configure do |conf|
        conf.disable 'multilib' unless enabled?
      end
    }
  }

  features {
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
    if host != target
      environment[:CPP] = "cpp --sysroot /usr/#{host}/#{target}"

      conf.with 'sysroot', "/usr/#{host}/#{target}"

      conf.with 'as', "/usr/bin/#{target}-as"
      conf.with 'ld', "/usr/bin/#{target}-ld"

      middle = "#{host}/#{target}"
    else
      middle = target.to_s
    end

    environment[:CXXFLAGS] = environment[:CFLAGS] = '-O2 -pipe'
    environment[:LDFLAGS]  = ''

    Do.dir "#{workdir}/build"
    Do.cd  "#{workdir}/build"

    conf.path = "#{workdir}/gcc-#{version}/configure"

    conf.set 'bindir',     "/usr/#{middle}/gcc-bin/#{version}"
    conf.set 'libdir',     "/usr/lib/gcc/#{middle}/#{version}"
    conf.set 'libexecdir', "/usr/lib/gcc/#{middle}/#{version}"
    conf.set 'includedir', "/usr/lib/gcc/#{middle}/#{version}/include"
    conf.set 'datadir',    "/usr/share/gcc-data/#{middle}/#{version}"
    conf.set 'infodir',    "/usr/share/gcc-data/#{middle}/#{package.version}/info"
    conf.set 'mandir',     "/usr/share/gcc-data/#{middle}/#{package.version}/man"

    conf.with 'gxx-include-dir', "/usr/lib/gcc/#{middle}/#{version}/include/g++v4"
    conf.with 'python-dir',      "/usr/share/gcc-data/#{middle}/#{version}/python"

    conf.enable  ['secureplt', 'shared']
    conf.disable ['werror', 'libmudflap', 'libssp', 'libgomp', 'bootstrap']
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
require 'packo'
require 'packo/models'
require 'packo/cli'

class Application < Thor
  include Packo

  class_option :help, :type => :boolean, :desc => 'Show help usage'

  desc 'list', 'List available GCC versions'
  def list
    CLI.info 'List of availaibale GCC versions'

    current = self.current

    self.versions.each {|target, versions|
      next if versions.empty?

      puts ''
      puts target.blue.bold

      versions.each_with_index {|version, i|
        puts (current[target] == version) ?
          "  {#{(i + 1).to_s.green}}    #{version}" :
          "  [#{i + 1             }]    #{version}"
      }
    }
  end

  desc "set VERSION [TARGET=#{System.host}]", 'Choose what version of GCC to use'
  def set (version, target=System.host.to_s)
    versions = self.versions[target]

    if version.numeric? && (version.to_i > versions.length || version.to_i < 1)
      CLI.fatal "#{version} out of index"
      exit 1
    end

    if version.numeric?
      version = versions[version.to_i - 1]
    end

    if !versions.member? version
      CLI.fatal "#{version} version not available for #{target}"
      exit 2
    end

    if target == System.host.to_s
      FileUtils.ln_sf Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/gcc-bin/#{version}/*"), "#{System.env![:INSTALL_PATH]}/usr/bin"
			FileUtils.ln_sf "#{System.env![:INSTALL_PATH]}/usr/lib/gcc/#{System.host}/#{version}/include/g++v4", "#{System.env![:INSTALL_PATH]}/usr/include/g++v4"
    else
      FileUtils.ln_sf Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/#{target}/gcc-bin/#{version}/#{target}-*"), "#{System.env![:INSTALL_PATH]}/usr/bin/"
    end

    CLI.info "Set gcc to #{version} for #{target}"

    Models::Selector.first(:name => 'gcc').update(:data => self.current.merge(target => version))
  end

  no_tasks {
    def current
      (Models::Selector.first(:name => 'gcc').data rescue nil) || {}
    end
  
    def versions
      versions = Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/*").select {|target|
        Host.parse(target.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/", '')) && !target.end_with?('-bin')
      }.map {|target|
        [target.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/", ''), Dir.glob("#{target}/gcc-bin/*").map {|version|
          Versionomy.parse(version.sub("#{target}/gcc-bin/", ''))
        }]
      }
  
      versions << [System.host.to_s, Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/gcc-bin/*").map {|version|
        Versionomy.parse(version.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/gcc-bin/", ''))
      }]
  
      Hash[versions]
    end
  }
end

Application.start(ARGV)

# gcc: Set the GCC version to use

$$$ patches/libstdc++-v3/crossconfig.patch $$$

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

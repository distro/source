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

  before :initialize, -10 do |pkg|
    pkg.languages = ['c']

    package.environment[:CXXFLAGS] = package.environment[:CFLAGS] = '-pipe'
    package.environment[:LDFLAGS]  = ''
  end

  before :dependencies do |deps|
    if package.target.kernel == 'cygwin'
      deps << 'library/system/development/cygwin!'
    end
  end

  before :configure do
    ['.', 'libiberty', 'libstdc++-v3', 'libjava'].each {|dir|
      Do.cd(dir) {
        package.autotools.autoconf
      }
    }

    Do.cd('gcc') {
      package.autotools.autoconf
      package.autotools.autoheader
    }

    Do.cd('libffi') {
      package.autotools.aclocal '-I', '.', '-I', '..', '-I', '../config'
      package.autotools.autoconf
    }

    ['boehm-gc', 'libffi', 'libgfortran', 'libgomp', 'libjava', 'libmudflap', 'libssp', 'libstdc++-v3', 'zlib'].each {|dir|
      Do.cd(dir) {
        package.autotools.automake
      }
    }
  end

  before :configure do |conf|
    Do.dir "#{package.workdir}/build"
    Do.cd  "#{package.workdir}/build"

    conf.path = "#{package.workdir}/gcc-#{package.version}/configure"

    middle = (package.host != package.target) ? "#{package.host}/#{package.target}" : "#{package.target}"

    conf.set 'bindir',     "/usr/#{middle}/gcc-bin/#{package.version}"
    conf.set 'libdir',     "/usr/lib/gcc/#{middle}/#{package.version}"
    conf.set 'libexecdir', "/usr/lib/gcc/#{middle}/#{package.version}"
    conf.set 'includedir', "/usr/lib/gcc/#{middle}/#{package.version}/include"
    conf.set 'datadir',    "/usr/share/gcc-data/#{middle}/#{package.version}"
    conf.set 'infodir',    "/usr/share/gcc-data/#{middle}/#{package.version}/info"
    conf.set 'mandir',     "/usr/share/gcc-data/#{middle}/#{package.version}/man"

    conf.with 'gxx-include-dir', "/usr/lib/gcc/#{middle}/#{package.version}/include/g++v4"
    conf.with 'python-dir',      "/usr/share/gcc-data/#{middle}/#{package.version}/python"

    conf.enable  ['secureplt']
    conf.disable ['werror', 'libmudflap', 'libssp', 'libgomp', 'shared', 'bootstrap']
    conf.with    ['system-zlib']
    conf.without ['ppl', 'cloog']

    # c, c++, fortran, ada, java, objc, objcp
    conf.enable 'languages', package.languages.join(',')

    conf.enable 'checking',   'release'
    conf.with   'pkgversion', "Distrø #{package.version}"

    # Various conditional configurations

    if package.host.kernel == 'cygwin'
      conf.enable 'threads', 'win32'
    else
      conf.enable 'threads', 'posix'
    end

    if package.target.kernel == 'darwin'
      conf.enable 'version-specific-runtime-libs'
    end

    if package.target.kernel == 'cygwin'
      conf.without 'libiberty'
    end

    if package.target.kernel == 'freebsd' || package.target.misc == 'gnu' || package.target.kernel == 'solaris'
      conf.enable '__cxa_atexit'
    end

    if package.target.misc == 'gnu'
      conf.enable 'clocale', 'gnu'
    end

    if package.environment[:LIBC] == 'newlib'
      conf.with 'newlib'
    end
  end

  before :compile do
    package.autotools.make '-j1'

    throw :halt
  end
}

__END__
$$$

$$$ patches/libstdc++-v3/crossconfig.patch $$$

--- crossconfig.m4.orig 2010-12-05 18:25:02.523371816 +0000
+++ crossconfig.m4  2010-12-05 18:25:11.576783185 +0000
@@ -141,7 +141,7 @@
 	;;
     esac
     ;;
-  *-linux* | *-uclinux* | *-gnu* | *-kfreebsd*-gnu | *-knetbsd*-gnu)
+  *-linux* | *-uclinux* | *-gnu* | *-kfreebsd*-gnu | *-knetbsd*-gnu | *-cygwin*)
     GLIBCXX_CHECK_COMPILER_FEATURES
     GLIBCXX_CHECK_LINKER_FEATURES
     GLIBCXX_CHECK_MATH_SUPPORT

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

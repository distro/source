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

    nls {
      before :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    openmp {

    }
  }

  before :initialize, -10 do |pkg|
    pkg.languages = ['c', 'c++']
  end

  before :dependencies do |deps|
    deps << 'library/system/development/cygwin!' if package.target.kernel == 'cygwin'
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
    Do.dir './build'
    Do.cd  './build'

    conf.path = '../configure'

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
    conf.without ['ppl', 'cloog', 'included-gettext']

    # c, c++, fortran, ada, java, objc, objcp
    conf.enable 'languages', package.languages.join(',')

    conf.enable 'checking',   'release'
    conf.with   'pkgversion', "Distrø #{package.version}"

    conf.with 'arch', package.target.arch
  end

  before :pack do
    package.slot = "#{package.slot}#{"-#{package.target.to_s}" if package.host != package.target}"
  end
}

__END__
$$$

$$$ patches/libstdc++-v3/crossconfig.patch $$$

--- crossconfig.m4.orig 2009-06-02 15:15:03.000000000 -0400
+++ crossconfig.m4      2010-08-22 22:35:55.345320303 -0400
@@ -141,7 +141,7 @@
        ;;
     esac
     ;;
-  *-linux* | *-uclinux* | *-gnu* | *-kfreebsd*-gnu | *-knetbsd*-gnu)
+  *-linux* | *-uclinux* | *-gnu* | *-kfreebsd*-gnu | *-knetbsd*-gnu | *-cygwin* )
     GLIBCXX_CHECK_COMPILER_FEATURES
     GLIBCXX_CHECK_LINKER_FEATURES
     GLIBCXX_CHECK_MATH_SUPPORT

$$$ patches/libtool.patch $$$

--- libtool.m4  (revision 128569)
+++ libtool.m4  (working copy)
@@ -5117,7 +5117,9 @@
   _LT_LINKER_SHLIBS($1)
   _LT_SYS_DYNAMIC_LINKER($1)
   _LT_LINKER_HARDCODE_LIBPATH($1)
-  LT_SYS_DLOPEN_SELF
+  if test "$cross_compiling" = no; then
+    LT_SYS_DLOPEN_SELF
+  fi
   _LT_CMD_STRIPLIB

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

    FileUtils.ln_sf Dir.glob("/usr/#{Packo::Host}/#{target}/gcc-bin/#{version}/*"), '/usr/bin/'

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

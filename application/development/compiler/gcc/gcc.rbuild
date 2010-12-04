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

  after :unpack do
    package.fs.patches.each {|name, file|
      package.patch file
    }
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

    conf.enable 'checking',   'release'
    conf.with   'pkgversion', "Distrø #{package.version}"

    conf.with 'arch', package.target.arch
  end

  before :pack do
    package.slot = "#{package.slot}#{"-#{package.target.to_s}" if package.host != package.target}"
  end
}

__END__
@@@

@@@ patches/crossconfig.patch @@@

--- libstdc++-v3/crossconfig.m4.orig 2009-06-02 15:15:03.000000000 -0400
+++ libstdc++-v3/crossconfig.m4      2010-08-22 22:35:55.345320303 -0400
@@ -141,7 +141,7 @@
        ;;
     esac
     ;;
-  *-linux* | *-uclinux* | *-gnu* | *-kfreebsd*-gnu | *-knetbsd*-gnu)
+  *-linux* | *-uclinux* | *-gnu* | *-kfreebsd*-gnu | *-knetbsd*-gnu | *-cygwin* )
     GLIBCXX_CHECK_COMPILER_FEATURES
     GLIBCXX_CHECK_LINKER_FEATURES
     GLIBCXX_CHECK_MATH_SUPPORT

@@@ selectors/select-gcc.rb @@@

# gcc: Set the gcc version to use

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

    self.versions.each_with_index {|version, i|
      puts " [#{version == current ? colorize(i + 1, :GREEN) : i + 1}] \t#{version}"
    }
  end

  desc 'Choose what version of gcc to use'
  def set (version)
    versions = self.versions

    if Packo.numeric?(version) && (version.to_i > versions.length || version.to_i < 1)
      fatal "#{version} out of index"
      exit 1
    end

    if Packo.numeric?(version)
      version = versions[version.to_i - 1]
    end

    if !versions.member? version
      fatal "#{version} version not available"
      exit 2
    end

    FileUtils.ln_sf "/usr/compilers/gcc/#{version}/bin/gcc", '/usr/bin/gcc'
    FileUtils.ln_sf "/usr/compilers/gcc/#{version}/bin/g++", '/usr/bin/g++'

    info "Set gcc to #{version}"

    Selector.first(:name => 'gcc').update(:data => version)
  end

  def current
    Selector.first(:name => 'gcc').data rescue nil
  end

  def versions
    Dir.glob('/usr/compilers/gcc/*').map {|version|
      version.sub('/usr/compilers/gcc/', '')
    }
  end
end

Application.dispatch

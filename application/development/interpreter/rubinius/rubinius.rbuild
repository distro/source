Package.define('rubinius') {
  avoid Modules::Building::Autotools
  use   Modules::Building::Rake

  tags 'application', 'interpreter', 'development', 'ruby'

  description 'An environment for the Ruby programming language providing performance, accessibility, and improved programmer productivity'
  homepage    'http://rubini.us/'
  license     'BSD'

  maintainer 'meh. <meh@paranoici.org>'

  source 'github://evanphx/rubinius/release-#{package.version}'

  dependencies << '>=library/system/development/llvm-2.8'

  after :unpack do
    Do.cd Dir.glob("#{workdir}/*").first
  end

  before :compile do
    environment[:LD]       = environment[:CXX]
    environment[:FAKEROOT] = distdir 

    conf = Modules::Building::Autotools::Configuration.new

    conf.set 'prefix',     (env[:INSTALL_PATH] + 'usr').cleanpath
    conf.set 'gemsdir',    (env[:INSTALL_PATH] + 'usr/lib/ruby').cleanpath
    conf.set 'bindir',     (env[:INSTALL_PATH] + 'usr/bin').cleanpath
    conf.set 'includedir', (env[:INSTALL_PATH] + 'usr/include/rubinius').cleanpath
    conf.set 'mandir',     (env[:INSTALL_PATH] + 'usr/share').cleanpath
    conf.set 'libdir',     (env[:INSTALL_PATH] + 'usr/lib/ruby').cleanpath
    conf.set 'sitedir',    (env[:INSTALL_PATH] + 'usr/lib/ruby/rubinius/site').cleanpath
    conf.set 'vendordir',  (env[:INSTALL_PATH] + 'usr/lib/ruby/rubinius/vendor').cleanpath

    Packo.sh "./configure #{conf}"

    package.rake.do 'build'

    throw :halt
  end

  after :install do
    [:rake, :rdoc, :ruby, :ri, :gem, :irb].each {|file|
      Do.rm("#{distdir}/usr/bin/#{file}")
    }
  end
}

__END__
$$$

$$$ patches/vm/external_libs/libtommath/makefile.patch $$$

--- makefile.orig	2011-02-11 14:44:15.379557003 +0100
+++ makefile	2011-02-11 14:44:25.053717503 +0100
@@ -18,7 +18,7 @@
 ifndef IGNORE_SPEED
 
 #for speed 
-CFLAGS += -O3 -funroll-loops -ggdb3
+#CFLAGS += -O3 -funroll-loops -ggdb3
 
 #for size 
 #CFLAGS += -Os

$$$ patches/vm/external_libs/libgdtoa/Makefile.patch $$$

--- Makefile.orig	2011-02-11 14:47:20.747826502 +0100
+++ Makefile	2011-02-11 14:48:20.876747003 +0100
@@ -25,7 +25,7 @@
 WARNINGS = -Wall
 DEBUG = -g -ggdb3
 
-CFLAGS = $(WARNINGS) $(DEBUG) -fno-strict-aliasing
+CFLAGS += $(WARNINGS) -fno-strict-aliasing
 NAME=libgdtoa
 VERSION = 1
 COMP=$(CC)
@@ -60,11 +60,11 @@
   OPTIMIZATIONS=
 else
   INLINE_OPTS=
-  OPTIMIZATIONS=-O2 -funroll-loops -finline-functions $(INLINE_OPTS)
+#  OPTIMIZATIONS=-O2 -funroll-loops -finline-functions $(INLINE_OPTS)
 endif
 
 ifeq ($(CPU), powerpc)
-  OPTIMIZATIONS+=-falign-loops=16
+#  OPTIMIZATIONS+=-falign-loops=16
 endif
 
 CFLAGS += -fPIC $(CPPFLAGS)

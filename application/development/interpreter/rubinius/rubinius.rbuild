Package.define('rubinius') {
  use Building::Rake

  tags 'application', 'interpreter', 'development', 'ruby'

  description 'An environment for the Ruby programming language providing performance, accessibility, and improved programmer productivity'
  homepage    'http://rubini.us/'
  license     'BSD'

  maintainer 'meh. <meh@paranoici.org>'

  source 'github://evanphx/rubinius/release-#{version}'

  dependencies << '>=library/system/development/llvm-2.8'

  after :unpack do
    Do.cd Dir.glob("#{workdir}/*").first
  end

  before :configure do |conf|
    env[:LD]       = env[:CXX]
    env[:FAKEROOT] = distdir 
    env[:RUBYOPT]  = '-rrubygems'
    env[:CFLAGS]  << '-Wno-error'

    conf.set 'prefix',     Path.clean(env[:INSTALL_PATH] + 'usr')
    conf.set 'gemsdir',    Path.clean(env[:INSTALL_PATH] + 'usr/lib/ruby')
    conf.set 'bindir',     Path.clean(env[:INSTALL_PATH] + 'usr/bin')
    conf.set 'includedir', Path.clean(env[:INSTALL_PATH] + 'usr/include/rubinius')
    conf.set 'mandir',     Path.clean(env[:INSTALL_PATH] + 'usr/share')
    conf.set 'libdir',     Path.clean(env[:INSTALL_PATH] + 'usr/lib/ruby')
    conf.set 'sitedir',    Path.clean(env[:INSTALL_PATH] + 'usr/lib/ruby/rubinius/site')
    conf.set 'vendordir',  Path.clean(env[:INSTALL_PATH] + 'usr/lib/ruby/rubinius/vendor')

    conf.execute
  end

  before :compile do |conf|
    package.rake.do 'build'

    skip
  end

  after :install do
    [:rake, :rdoc, :ruby, :ri, :gem, :irb].each {|file|
      package.do.rm("/usr/bin/#{file}")
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

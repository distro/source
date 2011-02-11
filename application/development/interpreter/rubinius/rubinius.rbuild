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

    conf.set 'prefix',     "#{System.env[:INSTALL_PATH]}/usr"
    conf.set 'gemsdir',    "#{System.env[:INSTALL_PATH]}/usr/lib/ruby"
    conf.set 'bindir',     "#{System.env[:INSTALL_PATH]}/usr/bin"
    conf.set 'includedir', "#{System.env[:INSTALL_PATH]}/usr/include/rubinius"
    conf.set 'mandir',     "#{System.env[:INSTALL_PATH]}/usr/share"
    conf.set 'libdir',     "#{System.env[:INSTALL_PATH]}/usr/lib/ruby"
    conf.set 'sitedir',    "#{System.env[:INSTALL_PATH]}/usr/lib/ruby/rubinius/site"
    conf.set 'vendordir',  "#{System.env[:INSTALL_PATH]}/usr/lib/ruby/rubinius/vendor"

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

$$$ patches/rakelib/vm.rake.patch $$$

--- vm.rake.orig	2011-02-11 15:11:53.031316502 +0100
+++ vm.rake	2011-02-11 15:11:59.855902502 +0100
@@ -330,7 +330,7 @@
   # Flag setup
 
   task :normal_flags do
-    FLAGS.concat %w[ -ggdb3 -O2 -Werror ]
+#    FLAGS.concat %w[ -ggdb3 -O2 -Werror ]
   end
 
   task :inline_flags => :normal_flags do

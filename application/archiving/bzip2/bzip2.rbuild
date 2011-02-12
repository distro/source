Package.define('bzip2') {
  tags 'application', 'archiving'

  description 'A high-quality data compressor'
  homepage    'http://www.bzip.org/'
  license     'BZIP2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://www.bzip.org/#{package.version}/bzip2-#{package.version}.tar.gz'

  flavor {
    static {
      description 'Build bzip2 statically linked against libbz2'

      after :install do
        package.do.bin 'bzip2-shared', 'bzip2' unless enabled?
      end
    }
  }

  before :configure do
    throw :halt
  end

  before :compile do
    autotools.make "CC=#{environment[:CC]}", "AR=#{environment[:AR]}", "RANLIB=#{environment[:RANLIB]}",
      '-f', 'Makefile-libbz2_so', 'all'

    environment[:CFLAGS] << '-static' if flavor.static?

    autotools.make "CC=#{environment[:CC]}", "AR=#{environment[:AR]}", "RANLIB=#{environment[:RANLIB]}",
      'all'

    throw :halt
  end

  before :install do
    autotools.make "PREFIX=#{distdir}/usr", 'LIBDIR=/usr/lib', 'install'

    [[:bzcat, :bzip2], [:bunzip2, :bzip2], [:bzcmp, :bzdiff], [:bzegrep, :bzgrep], [:bzless, :bzmore], [:bzfgrep, :bzgrep]].each {|(from, to)|
      package.do.into '/usr/bin' do
        package.do.sym to.to_s, from.to_s
      end
    }

    package.do.lib "libbz2.so.#{package.version}"

    package.do.into '/usr/lib' do
      package.do.sym "libbz2.so.#{package.version}", "libbz2.so.#{package.version.major}.#{package.version.minor}"
      package.do.sym "libbz2.so.#{package.version}", "libbz2.so.#{package.version.major}"
      package.do.sym "libbz2.so.#{package.version}", "libbz2.so"
    end

    throw :halt
  end
}

__END__
$$$

$$$ patches/Makefile.patch $$$

--- Makefile.orig	2011-02-12 14:35:45.283368002 +0100
+++ Makefile	2011-02-12 14:36:19.137432501 +0100
@@ -14,14 +14,8 @@
 
 SHELL=/bin/sh
 
-# To assist in cross-compiling
-CC=gcc
-AR=ar
-RANLIB=ranlib
-LDFLAGS=
-
 BIGFILES=-D_FILE_OFFSET_BITS=64
-CFLAGS=-Wall -Winline -O2 -g $(BIGFILES)
+CFLAGS += $(BIGFILES)
 
 # Where you want it installed when you do 'make install'
 PREFIX=/usr/local

$$$ patches/Makefile-libbz2_so $$$

--- Makefile-libbz2_so.orig	2011-02-12 14:36:57.222380501 +0100
+++ Makefile-libbz2_so	2011-02-12 14:37:19.313329501 +0100
@@ -21,10 +21,8 @@
 # ------------------------------------------------------------------
 
 
-SHELL=/bin/sh
-CC=gcc
 BIGFILES=-D_FILE_OFFSET_BITS=64
-CFLAGS=-fpic -fPIC -Wall -Winline -O2 -g $(BIGFILES)
+CFLAGS += -fpic -fPIC $(BIGFILES)
 
 OBJS= blocksort.o  \
       huffman.o    \

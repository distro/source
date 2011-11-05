maintainer 'meh. <meh@paranoici.org>'

use Helpers::Python

name 'justniffer'
tags 'application', 'network', 'sniffer'

description 'justniffer is a tcp packet sniffer that can log network traffic in a customizable way'
homepage    'http://justniffer.sourceforge.net/'
license     'GPL-3'

source 'sourceforge://justniffer/justniffer/justniffer%20#{version}/justniffer_#{version}'

dependencies.set {
	needs 'python%2'
}

after :unpack do
	py.fix_shebangs 'python/', 2
end

before :configure do |conf|
	autotools.configure conf rescue nil

	Do.cd 'lib/libnids-1.21_patched' do
		conf = conf.dup
		conf.disable ['libnet', 'libglib']
		autotools.configure conf rescue nil
	end

	skip
end

before :compile do |conf|
	Do.cd 'lib/libnids-1.21_patched' do
		autotools.make :clean
		autotools.make "-j#{env[:MAKE_JOBS] || 1}"
	end
end

__END__
$$$

$$$ patches/configure.patch $$$

--- configure.in.orig	2011-06-19 13:24:14.530397034 +0200
+++ configure.in	2011-06-19 13:24:29.343867725 +0200
@@ -26,7 +26,7 @@
 
 LIBNIDS="libnids-1.21_patched"
 NIDS2_INCLUDE="-I ../lib/$LIBNIDS/src"
-NIDS2_LIB="-L../lib/$LIBNIDS/src -lnids2"
+NIDS2_LIB="-L../lib/$LIBNIDS/src -lnids2-patched-static"
 PCAP_LIB="-lpcap"
 AC_SUBST(NIDS2_INCLUDE)
 AC_SUBST(NIDS2_LIB)

$$$ patches/lib/libnids-1.21_patched/src/Makefile.patch $$$

--- Makefile.in.orig	2011-06-19 13:31:50.031287351 +0200
+++ Makefile.in	2011-06-19 13:45:18.396257898 +0200
@@ -12,7 +12,7 @@
 includedir	= @includedir@
 libdir		= @libdir@
 mandir		= @mandir@
-LIBSTATIC      = libnids2.a
+LIBSTATIC      = libnids2-patched-static.a
 LIBSHARED      = libnids2.so.1.21
 
 CC		= @CC@
@@ -68,9 +68,6 @@
 	$(CC) -shared -Wl,-soname,$(LIBSHARED) -o $(LIBSHARED) $(OBJS_SHARED) $(LIBS) $(LNETLIB) $(PCAPLIB)
 
 _install install: $(LIBSTATIC)
-	../mkinstalldirs $(install_prefix)$(libdir)
-	../mkinstalldirs $(install_prefix)$(includedir)
-	../mkinstalldirs $(install_prefix)$(mandir)/man3
 	# we don't want to distribute the patched version of libnids. It is usefull just for justniffer
 	#$(INSTALL) -c -m 644 libnids2.a $(install_prefix)$(libdir)
 	#$(INSTALL) -c -m 644 nids2.h $(install_prefix)$(includedir)

$$$ patches/python/create_scripts.patch $$$

--- create_scripts.orig	2011-06-19 14:12:43.556760407 +0200
+++ create_scripts	2011-06-19 14:12:47.773466844 +0200
@@ -14,5 +14,3 @@
 out_file = open(out_filename, "w")
 out_file.write(c)
 out_file.close()
-
-print "******** "+ out_filename +" created ********"
\ No newline at end of file

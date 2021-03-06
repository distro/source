arch     'x86', 'x86_64'
kernel   'linux', 'windows'
compiler 'gcc'
libc     'glibc', 'newlib'

__END__
$$$

$$$ patches/install.patch $$$

--- Makefile.in.orig	2010-12-07 01:15:33.654400607 +0000
+++ Makefile.in	2010-12-07 01:17:35.134881840 +0000
@@ -137,23 +137,23 @@
 	cd testsuite && ${MAKE} AUTOCONF=${bindir}/autoconf $@
 
 installdirs:
-	$(SHELL) ${srcdir}/mkinstalldirs $(bindir) $(infodir) $(acdatadir)
+	$(SHELL) ${srcdir}/mkinstalldirs $(DESTDIR)$(bindir) $(DESTDIR)$(infodir) $(DESTDIR)$(acdatadir)
 
 install: all $(M4FILES) acconfig.h installdirs install-info
 	for p in $(ASCRIPTS); do \
-	  $(INSTALL_PROGRAM) $$p $(bindir)/`echo $$p|sed '$(transform)'`; \
+	  $(INSTALL_PROGRAM) $$p $(DESTDIR)$(bindir)/`echo $$p|sed '$(transform)'`; \
 	done
 	for i in $(M4FROZEN); do \
-	  $(INSTALL_DATA) $$i $(acdatadir)/$$i; \
+	  $(INSTALL_DATA) $$i $(DESTDIR)$(acdatadir)/$$i; \
 	done
 	for i in $(M4FILES) acconfig.h; do \
-	  $(INSTALL_DATA) $(srcdir)/$$i $(acdatadir)/$$i; \
+	  $(INSTALL_DATA) $(srcdir)/$$i $(DESTDIR)$(acdatadir)/$$i; \
 	done
 	-if test -f autoscan; then \
-	$(INSTALL_PROGRAM) autoscan $(bindir)/`echo autoscan|sed '$(transform)'`; \
+	$(INSTALL_PROGRAM) autoscan $(DESTDIR)$(bindir)/`echo autoscan|sed '$(transform)'`; \
 	for i in acfunctions acheaders acidentifiers acprograms \
 	  acmakevars; do \
-	$(INSTALL_DATA) $(srcdir)/$$i $(acdatadir)/$$i; \
+	$(INSTALL_DATA) $(srcdir)/$$i $(DESTDIR)$(acdatadir)/$$i; \
 	done; \
 	else :; fi
 
@@ -161,11 +161,11 @@
 install-info: info installdirs
 	if test -f autoconf.info; then \
 	  for i in *.info*; do \
-	    $(INSTALL_DATA) $$i $(infodir)/$$i; \
+	    $(INSTALL_DATA) $$i $(DESTDIR)$(infodir)/$$i; \
 	  done; \
 	else \
 	  for i in $(srcdir)/*.info*; do \
-	    $(INSTALL_DATA) $$i $(infodir)/`echo $$i | sed 's|^$(srcdir)/||'`; \
+	    $(INSTALL_DATA) $$i $(DESTDIR)$(infodir)/`echo $$i | sed 's|^$(srcdir)/||'`; \
 	  done; \
 	fi
 

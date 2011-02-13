Package.define('installwatch') {
  tags 'application', 'system'

  description 'Installwatch is an extremely simple utility to keep track of created and modified files during the installation of a new program.'
  homepage    'http://asic-linux.com.mx/~izto/checkinstall/installwatch.html'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://asic-linux.com.mx/~izto/checkinstall/files/source/installwatch-#{package.version}.tar.gz'

  before :configure do |conf|
    env[:PREFIX] = (env[:INSTALL_PATH] + '/usr').cleanpath

    throw :halt
  end
}

__END__
$$$

$$$ patches/Makefile.patch $$$

--- Makefile.orig	2011-02-13 22:27:37.206148000 +0100
+++ Makefile	2011-02-13 22:34:25.481907998 +0100
@@ -4,8 +4,6 @@
 # Well, the only configurable part is the following variable.
 # Make sure the directory you specify exists.
 
-PREFIX=/usr/local
-
 # End of configurable part
 
 VERSION=0.6.2
@@ -25,10 +23,13 @@
 	./create-localdecls
 
 install: all
-	if [ -r $(LIBDIR)/installwatch.so ]; then rm  $(LIBDIR)/installwatch.so; export LD_PRELOAD=""; cp installwatch.so $(LIBDIR); LD_PRELOAD=$(LIBDIR)/installwatch.so; else cp installwatch.so $(LIBDIR); fi
+	mkdir -p $(DESTDIR)/$(LIBDIR)
+	mkdir -p $(DESTDIR)/$(BINDIR)
+	
+	if [ -r $(DESTDIR)/$(LIBDIR)/installwatch.so ]; then rm  $(DESTDIR)/$(LIBDIR)/installwatch.so; export LD_PRELOAD=""; cp installwatch.so $(DESTDIR)/$(LIBDIR); LD_PRELOAD=$(DESTDIR)/$(LIBDIR)/installwatch.so; else cp installwatch.so $(DESTDIR)/$(LIBDIR); fi
 	
-	sed -e "s|#PREFIX#|$(PREFIX)|" < installwatch > $(BINDIR)/installwatch
-	chmod 755 $(BINDIR)/installwatch
+	sed -e "s|#PREFIX#|$(PREFIX)|" < installwatch > $(DESTDIR)/$(BINDIR)/installwatch
+	chmod 755 $(DESTDIR)/$(BINDIR)/installwatch
 
 uninstall:
 	rm $(LIBDIR)/installwatch.so

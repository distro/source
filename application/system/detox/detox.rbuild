Package.define('detox') {
  tags 'application', 'system'

  description 'Safely remove spaces and strange characters from filenames'
  homepage    'http://detox.sourceforge.net/'
  license     'BSD'

  dependencies << 'development/library/popt' << 'system/development/flex!' << 'system/development/bison!'

  source 'sourceforge://detox/detox/#{version}/detox-#{version}'

  before :configure do |conf|
    conf.with ['popt']
  end

  after :install do |conf|
    package.do.rm '/etc/detoxrc.sample'
    package.do.doc 'README', 'CHANGES'
  end
}

__END__
$$$

$$$ patches/Makefile.patch $$$

https://sourceforge.net/tracker/index.php?func=detail&aid=2166388&group_id=101612&atid=630105

--- Makefile.in	2008-10-14 16:37:22 +0000
+++ Makefile.in	2008-10-14 16:38:17 +0000
@@ -70,10 +70,10 @@
 #
 
 detox: ${detoxOBJS}
-	${CC} -o detox ${detoxOBJS} ${L_OPT}
+	${CC} ${LDFLAGS} -o detox ${detoxOBJS} ${L_OPT}
 
 inline-detox: ${inline-detoxOBJS}
-	${CC} -o inline-detox ${inline-detoxOBJS} ${L_OPT}
+	${CC} ${LDFLAGS} -o inline-detox ${inline-detoxOBJS} ${L_OPT}
 
 #
 # Special Source Compiles

$$$ patches/Makefile.2.patch $$$

https://sourceforge.net/tracker/index.php?func=detail&aid=2166387&group_id=101612&atid=630105

--- Makefile.in	2008-10-14 16:39:34 +0000
+++ Makefile.in	2008-10-14 16:38:51 +0000
@@ -131,7 +131,7 @@
 	${INSTALL} -m 644 detox.1 ${DESTDIR}${mandir}/man1
 	${INSTALL} -m 644 detoxrc.5 detox.tbl.5 ${DESTDIR}${mandir}/man5
 
-install-safe-config:
+install-safe-config: install-base
 	@if [ ! -f ${DESTDIR}${sysconfdir}/detoxrc ]; then \
 		${INSTALL} -m 644 detoxrc ${DESTDIR}${sysconfdir}; \
 	else \
@@ -148,12 +148,12 @@
 		echo "${DESTDIR}${datadir}/detox/unicode.tbl exists, skipping"; \
 	fi
 
-install-unsafe-config:
+install-unsafe-config: install-base
 	${INSTALL} -m 644 detoxrc ${DESTDIR}${sysconfdir}
 	${INSTALL} -m 644 iso8859_1.tbl ${DESTDIR}${datadir}/detox
 	${INSTALL} -m 644 unicode.tbl ${DESTDIR}${datadir}/detox
 
-install-sample-config:
+install-sample-config: install-base
 	${INSTALL} -m 644 detoxrc ${DESTDIR}${sysconfdir}/detoxrc.sample
 	${INSTALL} -m 644 iso8859_1.tbl ${DESTDIR}${datadir}/detox/iso8859_1.tbl.sample
 	${INSTALL} -m 644 unicode.tbl ${DESTDIR}${datadir}/detox/unicode.tbl.sample

Package.define('installwatch', '0.7.0beta7') {
  arch     'x86', 'x86_64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'

  source 'http://asic-linux.com.mx/~izto/checkinstall/files/source/checkinstall-1.6.2.tar.gz'

  after :unpack do
    Do.cd 'checkinstall-1.6.2/installwatch'
  end
}

__END__
$$$

$$$ patches/Makefile.patch $$$

--- Makefile.orig	2011-02-13 23:05:57.332509501 +0100
+++ Makefile	2011-02-13 23:06:44.768779500 +0100
@@ -4,8 +4,6 @@
 # Well, the only configurable part is the following variable.
 # Make sure the directory you specify exists.
 
-PREFIX=/usr/local
-
 # End of configurable part
 
 VERSION=0.7.0beta7
@@ -25,15 +23,15 @@
 	./create-localdecls
 
 install: all
-	mkdir -p $(LIBDIR)
-	mkdir -p $(BINDIR)
-	if [ -r $(LIBDIR)/installwatch.so ]; then \
-		rm -f  $(LIBDIR)/installwatch.so; \
+	mkdir -p $(DESTDIR)/$(LIBDIR)
+	mkdir -p $(DESTDIR)/$(BINDIR)
+	if [ -r $(DESTDIR)/$(LIBDIR)/installwatch.so ]; then \
+		rm -f  $(DESTDIR)/$(LIBDIR)/installwatch.so; \
 	fi
-	install installwatch.so $(LIBDIR)
+	install installwatch.so $(DESTDIR)/$(LIBDIR)
 	
-	sed -e "s|#PREFIX#|$(PREFIX)|" < installwatch > $(BINDIR)/installwatch
-	chmod 755 $(BINDIR)/installwatch
+	sed -e "s|#PREFIX#|$(PREFIX)|" < installwatch > $(DESTDIR)/$(BINDIR)/installwatch
+	chmod 755 $(DESTDIR)/$(BINDIR)/installwatch
 
 uninstall:
 	rm -f $(LIBDIR)/installwatch.so

$$$ patches/create-localdecl.sh $$$

--- create-localdecls.orig	2011-02-14 00:42:18.365547001 +0100
+++ create-localdecls	2011-02-14 00:49:45.894670500 +0100
@@ -64,37 +64,9 @@
 	case "$OsLibcMajor" in
 	2)
 		# 2 is the glibc version
-		case "$OsLibcMinor" in
-		0)
-			echo '#define GLIBC_MINOR 0' >> $OUTFILE
-			SUBVERSION='glibc-2.0' ;;
-		1)
-			echo '#define GLIBC_MINOR 1' >> $OUTFILE
-			SUBVERSION='glibc-2.1' ;;
-		2)
-			echo '#define GLIBC_MINOR 2' >> $OUTFILE
-			SUBVERSION='glibc-2.2' ;;
-		3)
-			echo '#define GLIBC_MINOR 3' >> $OUTFILE
-			SUBVERSION='glibc-2.3' ;;
-		4)
-			echo '#define GLIBC_MINOR 4' >> $OUTFILE
-			SUBVERSION='glibc-2.4' ;;
-		5)
-			echo '#define GLIBC_MINOR 5' >> $OUTFILE
-			SUBVERSION='glibc-2.5' ;;
-		6)
-			echo '#define GLIBC_MINOR 6' >> $OUTFILE
-			SUBVERSION='glibc-2.6' ;;
-		7)
-			echo '#define GLIBC_MINOR 7' >> $OUTFILE
-			SUBVERSION='glibc-2.7' ;;
-		*)
-			echo 'Treated as glibc >= 2.1 (finger crossed)'
-			echo '#define GLIBC_MINOR 1' >> $OUTFILE
-			SUBVERSION='glibc-2.1' ;;
-	        esac
-		;;
+        SUBVERSION="glibc-${OsLibcMajor}.${OsLibcMinor}"
+        echo "#define GLIBC_MINOR ${OsLibcMinor}" >> $OUTFILE
+        echo $SUBVERSION
 	esac
 fi
 
$$$ patches/installwatch.c $$$

--- installwatch.c	2008-11-16 17:20:53.000000000 +0100
+++ installwatch.c	2011-02-13 22:06:36.237947501 +0100
@@ -98,9 +98,20 @@
 static int (*true_rmdir)(const char *);
 static int (*true_xstat)(int,const char *,struct stat *);
 static int (*true_lxstat)(int,const char *,struct stat *);
+
+#if(GLIBC_MINOR >= 10)
+
+static int (*true_scandir)(	const char *,struct dirent ***,
+				int (*)(const struct dirent *),
+				int (*)(const struct dirent **,const struct dirent **));
+
+#else
+
 static int (*true_scandir)(	const char *,struct dirent ***,
 				int (*)(const struct dirent *),
 				int (*)(const void *,const void *));
+#endif
+
 static int (*true_symlink)(const char *, const char *);
 static int (*true_truncate)(const char *, TRUNCATE_T);
 static int (*true_unlink)(const char *);
@@ -118,9 +129,16 @@
 static int (*true_ftruncate64)(int, __off64_t);
 static int (*true_open64)(const char *, int, ...);
 static struct dirent64 *(*true_readdir64)(DIR *dir);
+
+#if(GLIBC_MINOR >= 10)
+static int (*true_scandir64)(	const char *,struct dirent64 ***,
+				int (*)(const struct dirent64 *),
+				int (*)(const struct dirent64 **,const struct dirent64 **));
+#else
 static int (*true_scandir64)(	const char *,struct dirent64 ***,
 				int (*)(const struct dirent64 *),
 				int (*)(const void *,const void *));
+#endif
 static int (*true_xstat64)(int,const char *, struct stat64 *);
 static int (*true_lxstat64)(int,const char *, struct stat64 *);
 static int (*true_truncate64)(const char *, __off64_t);
@@ -3079,7 +3097,11 @@
 
 int scandir(	const char *dir,struct dirent ***namelist,
 		int (*select)(const struct dirent *),
+#if (GLIBC_MINOR >= 10)
+		int (*compar)(const struct dirent **,const struct dirent **)	) {
+#else
 		int (*compar)(const void *,const void *)	) {
+#endif
 	int result;
 
 	if (!libc_handle)
@@ -3691,7 +3713,11 @@
 
 int scandir64(	const char *dir,struct dirent64 ***namelist,
 		int (*select)(const struct dirent64 *),
+#if (GLIBC_MINOR >= 10)
+		int (*compar)(const struct dirent64 **,const struct dirent64 **)	) {
+#else
 		int (*compar)(const void *,const void *)	) {
+#endif
 	int result;
 
 	if (!libc_handle)

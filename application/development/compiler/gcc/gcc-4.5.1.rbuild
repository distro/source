Package.define('gcc', '4.5.1', '4.5') {
  arch     'x86', 'x86_64'
  kernel   'linux', 'windows'
  compiler 'gcc'
  libc     'glibc', 'newlib'

  autotools.version :autoconf, '2.64'
}

__END__
$$$

$$$ patches/libtool.patch $$$

--- libtool.m4.orig 2010-12-05 18:22:45.529620177 +0000
+++ libtool.m4  2010-12-05 18:23:20.112471032 +0000
@@ -5370,7 +5370,9 @@
   _LT_LINKER_SHLIBS($1)
   _LT_SYS_DYNAMIC_LINKER($1)
   _LT_LINKER_HARDCODE_LIBPATH($1)
-  LT_SYS_DLOPEN_SELF
+  if test "$cross_compiling" = no; then
+    LT_SYS_DLOPEN_SELF
+  fi
   _LT_CMD_STRIPLIB
 
   # Report which library types will actually be built

$$$

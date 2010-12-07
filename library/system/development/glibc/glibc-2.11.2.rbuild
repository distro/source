Package.define('glibc', '2.11.2') {
  arch     'x86', 'amd64'
  kernel   'linux'
  compiler 'gcc'
}

__END__
$$$

$$$ patches/makeconfig.patch $$$

--- Makeconfig.orig	2010-12-06 16:51:43.812493758 +0000
+++ Makeconfig	2010-12-06 16:52:14.908645685 +0000
@@ -542,8 +542,8 @@
 else
  libgcc_eh := -Wl,--as-needed -lgcc_s$(libgcc_s_suffix) $(libunwind) -Wl,--no-as-needed
 endif
-gnulib := -lgcc $(libgcc_eh)
-static-gnulib := -lgcc -lgcc_eh $(libunwind)
+gnulib := -lgcc # $(libgcc_eh)
+static-gnulib := -lgcc # -lgcc_eh $(libunwind)
 libc.so-gnulib := -lgcc
 endif
 ifeq ($(elf),yes)

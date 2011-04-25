Package.define('linux', '2.6.32.39') {
  arch     '~x86', '~amd64'
  compiler 'gcc'
  libc     'glibc'

  source 'http://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/linux-2.6.32.28.tar.bz2'

  zen!        'http://downloads.zen-kernel.org/2.6.32/2.6.32-zen7.patch.lzma'
  grsecurity! 'http://grsecurity.net/stable/grsecurity-2.2.1-2.6.32.28-201101272313.patch'
}

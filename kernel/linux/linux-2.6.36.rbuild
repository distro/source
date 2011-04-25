Package.define('linux', '2.6.36') {
  arch     '~x86', '~amd64'
  compiler 'gcc'
  libc     'glibc'

  zen! 'http://downloads.zen-kernel.org/2.6.36/2.6.36-zen2.patch.lzma'
}

Package.define('linux', '2.6.37') {
  arch     '~x86', '~amd64'
  compiler 'gcc'
  libc     'glibc'

  grsecurity! 'http://grsecurity.net/test/grsecurity-2.2.1-2.6.37-201101272240.patch'
}

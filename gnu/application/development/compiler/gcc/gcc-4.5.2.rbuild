Package.define('gcc', '4.5.2', '4.5') {
  arch     'x86', 'x86_64'
  kernel   'linux', 'windows'
  compiler 'gcc'
  libc     'glibc', 'newlib'

  autotools.version :autoconf, '2.64'
}

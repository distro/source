# Maintainer: meh. <meh@paranoici.org>

Packo::Package.new('system/development/gcc', '4.4.3', '4.4') {
  arch     '~x86', '~amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'
}

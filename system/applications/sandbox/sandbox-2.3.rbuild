# Maintainer: meh. <meh@paranoici.org>

Packo::Package.new('system/applications/sandbox', '2.3') {
  arch     '~x86', '~amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'
}

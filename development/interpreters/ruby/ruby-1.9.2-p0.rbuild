# Maintainer: meh. <meh@paranoici.org>

Packo::Package.new('development/interpreters/ruby', '1.9.2-p0', '1.9') {
  arch     '~x86', '~amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'
}

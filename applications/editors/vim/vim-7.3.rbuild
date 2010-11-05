# Maintainer: meh. <meh@paranoici.org>

Packo::Package.new('applications/editors/vim', '7.3') {
  arch     '~x86', '~amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'

  autotools.version :autoconf, '2.6'
}

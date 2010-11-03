# Maintainer: meh. <meh@paranoici.org>

Packo::Package.new('applications/editors/vim', '7.3') {
  archs '~x86', '~amd64'

  autotools.version :autoconf, '2.6'
}

# Maintainer: meh. <meh@paranoici.org>

Packo::Package.new(['system', 'library', 'text'], 'ncurses', '5.7') {
  arch     '~x86', '~amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'
}

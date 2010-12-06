Package.define('glibc') { type 'libc'
  behavior Behaviors::GNU
  use      Modules::Fetching::GNU

  maintainer 'meh. <meh@paranoici.org>'

  tags 'library', 'system', 'libc'

  description 'GNU libc6 (also called glibc2) C library'
  homepage    'http://www.gnu.org/software/libc/libc.html'
  license     'LGPL-2'

  source 'glibc/#{package.version}'
}

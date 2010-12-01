Package.define('cygwin') { type 'library'
  behavior Behaviors::GNU
  
  maintainer 'meh. <meh@paranoici.org>'

  tags 'library', 'system', 'development'

  description 'Linux-like environment for Windows'
  homepage    'http://cygwin.com/'
  license     'GPL-2'

  source 'ftp://sourceware.org/pub/cygwin/release/cygwin/cygwin-#{package.version}-#{package.revision + 1}-src.tar.bz2'
}

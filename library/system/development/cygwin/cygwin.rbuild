Package.define('cygwin') { type 'library'
  behavior Behaviors::GNU
  
  maintainer 'meh. <meh@paranoici.org>'

  tags 'library', 'system', 'development'

  description 'Linux-like environment for Windows'
  homepage    'http://cygwin.com/'
  license     'GPL-2'

  source 'ftp://sourceware.org/pub/cygwin/release/cygwin/cygwin-#{package.version}-#{package.revision + 1}-src.tar.bz2'

  after :unpack do
    Do.cd "#{package.workdir}/#{package.name}-#{package.version}-#{package.revision + 1}"
  end

  before :configure do |conf|
    next unless package.host != package.target

    conf.clear
    conf.set 'target', package.target

    Do.cd 'winsup/cygwin'
  end

  before :compile do
    throw :halt
  end

  before :install do |conf|
    next unless package.host != package.target

    Do.into "#{package.distdir}/usr/#{package.target}/usr/include"
    Do.ins '../../winsup/w32api/include/.', :recursive => true
    Do.ins '../../newlib/libc/include/.', :recursive => true
    Do.sym 'usr/include', '../../sys-include'

    package.autotools.make 'install-headers', "tooldir='/usr/#{package.target}/usr'", "DESTDIR='#{package.distdir}'"

    throw :halt
  end
}

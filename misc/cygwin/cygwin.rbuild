Package.define('cygwin') {
  tags 'misc', 'kernel'

  description 'Linux-like environment for Windows'
  homepage    'http://cygwin.com/'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'ftp://sourceware.org/pub/cygwin/release/cygwin/cygwin-#{package.version}-#{package.revision + 1}-src.tar.bz2'

  after :unpack do
    Do.cd "#{package.workdir}/#{package.name}-#{package.version}-#{package.revision + 1}"
  end

  before :configure do |conf|
    next unless package.host != package.target

    conf.clear
    conf.set 'target', package.target
  end

  before :install do |conf|
=begin
    next unless package.host != package.target

    middle = (package.host != package.target) ? "#{package.host}/#{package.target}" : "#{package.target}"
    
    package.do.into("/usr/#{middle}/usr/include") {
      package.do.ins '../../winsup/w32api/include/*'
      package.do.ins '../../newlib/libc/include/*'
      package.do.sym 'usr/include', '../../sys-include'
    }

    package.autotools.make 'install-headers', "tooldir='/usr/#{middle}/usr'", "DESTDIR='#{package.distdir}'"

    skip
=end
  end
}

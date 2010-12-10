Package.define('sandbox') {
  behavior Behaviors::Standard

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'system'
  
  description "Gentoo's sandbox utility for more secure package building"
  homepage    'http://www.gentoo.org/'
  license     'GPL-2'

  source 'http://dev.gentoo.org/~vapier/dist/sandbox-#{package.version}.tar.xz'

  dependencies << 'application/archive/xz!' << 'application/utility/pax!'

  after :install do
    File.write("#{package.distdir}/etc/sandbox.d/09sandbox", package.filesystem.files.sandbox)
    File.write("#{package.distdir}/etc/sandbox.d/10packo", package.filesystem.files.packo)
  end
}

__END__
@@@

@@@ files/sandbox @@@

CONFIG_PROTECT_MASK="/etc/sandbox.d"

@@@ files/packo @@@

SANDBOX_READ="/var/lib/packo"
SANDBOX_WRITE="/var/lib/packo"

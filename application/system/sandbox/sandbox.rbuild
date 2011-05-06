Package.define('sandbox') {
  tags 'application', 'system'
  
  description "Gentoo's sandbox utility for more secure package building"
  homepage    'http://www.gentoo.org/'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://dev.gentoo.org/~vapier/dist/sandbox-#{package.version}.tar.xz'

  after :install do
    File.write("#{package.distdir}/etc/sandbox.d/09sandbox", package.filesystem['files/sandbox'])
    File.write("#{package.distdir}/etc/sandbox.d/10packo", package.filesystem['files/packo'])
  end
}

__END__
$$$

$$$ files/sandbox $$$

CONFIG_PROTECT_MASK="/etc/sandbox.d"

$$$ files/packo $$$

SANDBOX_READ="/var/lib/packo"
SANDBOX_WRITE="/var/lib/packo"

SANDBOX_READ="${HOME}/.packo"
SANDBOX_WRITE="${HOME}/.packo"

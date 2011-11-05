maintainer 'meh. <meh@paranoici.org>'

name 'sandbox'
tags 'application', 'system'

description "Gentoo's sandbox utility for more secure package building"
homepage    'http://www.gentoo.org/'
license     'GPL-2'

source 'http://dev.gentoo.org/~vapier/dist/sandbox-#{version}.tar.xz'

after :install do
	package.filesystem['/files/sandbox'].save("#{package.distdir}/etc/sandbox.d/09sandbox")
	package.filesystem['/files/packo'].save("#{package.distdir}/etc/sandbox.d/10packo")
end

__END__
$$$

$$$ files/sandbox $$$

CONFIG_PROTECT_MASK="/etc/sandbox.d"

$$$ files/packo $$$

SANDBOX_READ="/var/lib/packo"
SANDBOX_WRITE="/var/lib/packo"

SANDBOX_READ="${HOME}/.packo"
SANDBOX_WRITE="${HOME}/.packo"

Package.define('sandbox') {
  behavior Behaviors::GNU

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'system'
  
  description "Gentoo's sandbox utility for more secure package building"
  homepage    'http://www.gentoo.org/'
  license     'GPL-2'

  source 'http://dev.gentoo.org/~vapier/dist/sandbox-#{package.version}.tar.xz'

  dependencies << 'application/archive/xz!' << 'application/utility/pax!'

  features {
    multilib {

    }
  }

  after :install do
    File.write("#{package.distdir}/etc/sandbox.d/09sandbox", package.fs.files.sandbox.content)
    File.write("#{package.distdir}/etc/sandbox.d/10packo", package.fs.files.packo.content)
  end
}

__END__
@@@

@@@ files/sandbox @@@

CONFIG_PROTECT_MASK="/etc/sandbox.d"

@@@ files/packo @@@

SANDBOX_READ="/var/lib/packo"
SANDBOX_WRITE="/var/lib/packo"

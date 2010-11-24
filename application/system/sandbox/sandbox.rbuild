# Maintainer: meh. <meh@paranoici.org>

Package.define(['system', 'applications'], 'sandbox') {
  behavior Behaviors::GNU
  
  description "Gentoo's sandbox utility for more secure package building"
  homepage    'http://www.gentoo.org/'
  license     'GPL-2'

  source 'http://dev.gentoo.org/~vapier/dist/sandbox-#{package.version}.tar.xz'

  dependencies << 'application/archive/xz!' << 'application/utility/pax!'

  features {
    multilib {

    }
  }
}

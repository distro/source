# Maintainer: meh. <meh@paranoici.org>

require 'packo/behaviors/gnu'

Packo::Package.new('system/applications/sandbox') {
  behavior Packo::Behaviors::GNU
  
  description "Gentoo's sandbox utility for more secure package building"
  homepage    'http://www.gentoo.org/'
  license     'GPL-2'

  source 'http://dev.gentoo.org/~vapier/dist/sandbox-#{package.version}.tar.xz'

  dependencies << 'applications/archiving/xz!' << 'applications/misc/pax-utils!'

  features {
    multilib {

    }
  }
}

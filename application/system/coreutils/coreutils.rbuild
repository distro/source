# Maintainer: meh. <meh@paranoici.org>

Package.define(['application', 'system'], 'coreutils') {
  behavior Behaviors::GNU
  use      Modules::Fetching::GNU
  
  description 'Standard GNU file utilities (chmod, cp, dd, dir, ls...), text utilities (sort, tr, head, wc..), and shell utilities (whoami, who,...)'
  homepage    'http://www.gnu.org/software/coreutils/'
  license     'GPL-3'

  source 'coreutils/#{package.version}'

  dependencies << '>=system/library/ncurses-5.3'
  dependencies << 'application/archive/xz!'

  features {
    nls {
      before :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    caps {
      before :configure do |conf|
        if enabled?
          conf.enable 'caps'
        else
          conf.disable 'libcap'
        end
      end
    }

    acl {
      before :configure do |conf|
        conf.enable 'acl', enabled?
      end
    }

    xattr {
      before :configure do |conf|
        conf.enable 'xattr', enabled?
      end
    }

    gmp {
      before :configure do |conf|
        conf.with 'gmp', enabled?
      end
    }
  }

  before :configure do |conf|
    conf.with 'packager', 'Distrø'

    conf.enable 'install-program', 'arch'
    conf.enable 'no-install-program', 'groups,hostname,kill,su,uptime'
    conf.enable 'largefile'
  end
}

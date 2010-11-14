# Maintainer: meh. <meh@paranoici.org>

require 'packo/behaviors/gnu'
require 'packo/modules/fetching/gnu'

Packo::Package.new('system/applications/coreutils') {
  behavior Packo::Behaviors::GNU
  use      Packo::Modules::Fetching::GNU
  
  description 'Standard GNU file utilities (chmod, cp, dd, dir, ls...), text utilities (sort, tr, head, wc..), and shell utilities (whoami, who,...)'
  homepage    'http://www.gnu.org/software/coreutils/'
  license     'GPL-3'

  source 'coreutils/#{package.version}'

  dependencies << '>=system/libraries/ncurses-5.3'
  dependencies << 'applications/archiving/xz!'

  blockers << '<system/applications/util-linux-2.13' << 'system/applications/stat' << 'network/mail/base64' <<
              'system/applications/mktemp'

  features {
    nls {
      on :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    caps {
      on :configure do |conf|
        if enabled?
          conf.enable 'caps'
        else
          conf.disable 'libcap'
        end
      end
    }

    acl {
      on :configure do |conf|
        conf.enable 'acl', enabled?
      end
    }

    xattr {
      on :configure do |conf|
        conf.enable 'xattr', enabled?
      end
    }

    gmp {
      on :configure do |conf|
        conf.with 'gmp', enabled?
      end
    }
  }

  on :configure do |conf|
    conf.with 'packager', 'Distrø'

    conf.enable 'install-program', 'arch'
    conf.enable 'no-install-program', 'groups,hostname,kill,su,uptime'
    conf.enable 'largefile'
  end
}

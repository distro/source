# Maintainer: Ermenegildo Fiorito (fyskij) <fiorito.g@gmail.com)

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

  features {
    nls {
      on :dependencies do |package|
        package.dependencies << 'system/development/gettext' if enabled?
      end

      on :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    cups {
      on :dependencies do |package|
        package.dependencies << 'network/printing/cups' if enabled?
      end

      on :configure do |conf|
        conf.enable 'cups', enabled?
      end
    }

    acl {
      on :dependencies do |package|
        package.dependencies << 'system/applications/acl' if enabled?
      end

      on :configure do |conf|
        conf.enable 'acl', enabled?
      end
    }

    attr {
      on :dependencies do |package|
        package.dependencies << 'system/applications/attr' if enabled?
      end
      
      on :configure do |conf|
        conf.enable 'attr', enabled?
      end
    }

    gmp { enabled!
      on :dependencies do |package|
        package.dependencies << 'development/libraries/gmp' if enabled?
      end

      on :configure do |conf|
        conf.enable 'gmp', enabled?
      end
    }
  }

  on :configure do |conf|
    conf.enable 'install-program', 'arch'
    conf.enable 'no-install-program', 'groups,hostname,kill,su,uptime'
    conf.enable 'largefile'
  end
}

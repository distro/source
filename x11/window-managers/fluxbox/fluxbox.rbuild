require 'packo/behaviors/gnu'
require 'packo/modules/sourceforge'

Packo::Package.new('x11/window-managers/fluxbox') {
  behavior Packo::Behaviors::GNU
  use Packo::Modules::SourceForge

  description 'Fluxbox is an X11 window manager featuring tabs and an iconbar'
  homepage    'http://www.fluxbox.org'
  license     'MIT'

  source 'fluxbox/#{package.version}'

  dependencies << 'x11/libraries/libXft' << 'x11/libraries/libXpm' << 'x11/applications/xmessage'
  dependencies << 'x11/protocol/xextproto!'

  features {
    nls {
      on :dependencies do |package|
        package.dependencies << 'system/development/gettext!' if enabled?
      end

      on :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    xinerama {
      on :dependencies do |package|
        package.dependencies << 'x11/libraries/libXinerama' << 'x11/protocols/xineramaproto!' if enabled?
      end

      on :configure do |conf|
        conf.enable 'xinerama', enabled?
      end
    }

    truetype {
      on :dependencies do |package|
        package.dependencies << 'media/libraries/freetype'
      end

      on :configure do |conf|
        conf.enable 'xft', enabled?
      end
    }

    gnome {
      on :configure do |conf|
        conf.enable 'gnome', enabled?
      end
    }

    imlib { enabled!
      on :dependencies do |package|
        package.dependencies << '>=media/libraries/imlib2-1.2.0[X]' if enabled?
      end

      on :configure do |conf|
        conf.enable 'imlib2', enabled?
      end
    }

    slit { enabled!
      on :configure do |conf|
        conf.enable 'slit', enabled?
      end
    }

    toolbar { enabled!
      on :configure do |conf|
        conf.enable 'toolbar', enabled?
      end
    }

    vim {
      
    }

    newmousefocus {

    }
  }

  on :configure do |conf|
    conf.set 'sysconfdir', "#{package.distdir}/etc/X11/fluxbox"
  end
}

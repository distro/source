Package.define('fluxbox') {
  behavior Behaviors::GNU
  use      Modules::Fetching::SourceForge

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'x11', 'window-manager'

  description 'Fluxbox is an X11 window manager featuring tabs and an iconbar'
  homepage    'http://www.fluxbox.org'
  license     'MIT'

  source 'fluxbox/#{package.version}'

  dependencies << 'x11/library/Xft' << 'x11/library/Xpm' << 'x11/application/xmessage'
  dependencies << 'x11/protocol/xext!'

  features {
    nls {
      before :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    xinerama {
      before :configure do |conf|
        conf.enable 'xinerama', enabled?
      end
    }

    truetype {
      before :configure do |conf|
        conf.enable 'xft', enabled?
      end
    }

    gnome {
      before :configure do |conf|
        conf.enable 'gnome', enabled?
      end
    }

    imlib { enabled!
      before :dependencies do |deps|
        deps << '>=media/library/imlib2-1.2.0[X]' if enabled?
      end

      before :configure do |conf|
        conf.enable 'imlib2', enabled?
      end
    }

    slit { enabled!
      before :configure do |conf|
        conf.enable 'slit', enabled?
      end
    }

    toolbar { enabled!
      before :configure do |conf|
        conf.enable 'toolbar', enabled?
      end
    }

    newmousefocus {

    }

    vim {
      
    }
  }

  before :configure do |conf|
    conf.set 'sysconfdir', '/etc/X11/fluxbox'
  end
}

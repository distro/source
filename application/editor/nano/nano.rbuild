Package.define('nano') {
  tags 'application', 'editor'

  description 'Clone of the Pico text editor with some enhancements.'
  homepage    'http://www.nano-editor.org/'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>' 

  source 'http://www.nano-editor.org/dist/v#{package.version.major}.#{package.version.minor}/nano-#{package.version}.tar.gz'

  flavor {
    debug {
      before :configure do |conf|
        conf.enable 'debug', enabled?
      end
    }

    minimal {
      before :configure do |conf|
        if disabled?
          conf.enable ['color', 'multibuffer', 'nanorc']
        else
          conf.enable 'tiny'
        end
      end
    }
  }

  features {
    ncurses {
      needs '!slang'

      before :configure do |conf|
        conf.with 'slang', disabled?
      end
    }

    slang {
      needs '!ncurses'

      before :configure do |conf|
        conf.with 'slang', enabled?
      end
    }

    spell {
      before :configure do |conf|
        conf.enable 'speller', enabled?
      end
    }

    nls {
      before :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }

    unicode {
      before :configure do |conf|
        conf.enable 'utf8'
      end
    }

    justify {
      before :cnfigure do |conf|
        conf.enable 'justify', enabled?
      end
    }
  }

  before :configure do |conf|
    conf.disable 'wrapping-as-root'
  end

  after :install do
    package.do.doc 'ChangeLog', 'README', 'doc/nanorc.sample', 'AUTHORS', 'BUGS', 'NEWS', 'TODO'
    package.do.html 'doc/faq.html'
  end
}

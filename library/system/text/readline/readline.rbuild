Package.define('readline') { type 'library'
  tags 'library', 'system', 'text', 'gnu'

  description 'GNU readline library'
  homepage    'http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html'
  license     'GPL-3'

  maintainer  'shura <shura1991@gmail.com>'

  source      'gnu://readline/#{version}'

  flavor {
    needs 'vanilla || static || shared'

    static {
      before :configure do |conf|
        conf.enable 'static', enabled?
      end
    }

    shared {
      before :configure do |conf|
        conf.enable 'shared', enabled?
      end
    }

    vanilla {
      after :initialized do
        package.flavor.static!
        package.flavor.shared!
      end
    }
  }

  features {
    multibyte { enabled!
      before :configure do |conf|
        conf.enable 'multibyte' if enabled?
      end
    }

    ncurses { enabled!
      before :dependecies do |deps|
        deps << 'library/system/text/ncurses' if enabled?
      end

      before :configure do |conf|
        conf.with 'curses' if enabled?
      end
    }
  }
}

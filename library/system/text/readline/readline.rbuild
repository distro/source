Package.define('readline') { type 'library'
  tags 'library', 'system', 'test', 'gnu'

  description 'GNU readline library'
  homepage    'http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html'
  license     'GPL-3'

  maintainer  'shura <shura1991@gmail.com>'

  source      'gnu://readline/#{version}'

  flavor {
    needs 'static || shared'

    static { enabled!
      before :configure do |conf|
        conf.enable 'static', enabled?
      end
    }

    shared { enabled!
      before :configure do |conf|
        conf.enable 'shared', enabled?
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

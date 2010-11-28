Package.define('vim') {
  behavior Behaviors::GNU

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'editor'

  description 'Vim, an improved vi-style text editor'
  homepage    'http://www.vim.org/'
  license     'vim'

  source 'ftp://ftp.vim.org/pub/vim/unix/vim-#{package.version}.tar.bz2'

  features {
    ruby {
      before :configure do |conf|
        conf.enable 'rubyinterp', enabled?
      end
    }

    perl {
      before :configure do |conf|
        conf.enable 'perlinterp', enabled?
      end
    }

    mzscheme {
      before :configure do |conf|
        conf.enable 'mzschemeinterp', enabled?
      end
    }

    lua {
      before :configure do |conf|
        conf.enable 'luainterp', enabled?
      end
    }

    tcl {
      before :configure do |conf|
        conf.enable 'tclinterp', enabled?
      end
    }

    python {
      before :dependencies do |deps|
        deps << 'development/interpreter/python%2'
      end

      before :configure do |conf|
        conf.enable 'pythoninterp', enabled?
      end
    }

    python3 {
      before :dependencies do |deps|
        deps << 'development/interpreter/python%3'
      end

      before :configure do |conf|
        conf.enable 'python3interp', enabled?
      end
    }

    X {
      before :configure do |conf|
        conf.with 'x', enabled?
      end
    }

    gtk {
      needs 'X'

      before :configure do |conf|
        if enabled?
          conf.enable 'gtk2-check'
          conf.enable 'gui', 'gtk2'
        end
      end
    }

    gnome {
      needs 'X'

      before :configure do |conf|
        if enabled?
          conf.enable 'gtk2-check'
          conf.enable 'gui', 'gnome2'
        end
      end
    }

    netbeans {
      before :configure do |conf|
        conf.enable 'netbeans', enabled?
      end
    }

    cscope {
      before :dependencies do |deps|
        deps << 'development/utility/cscope'
      end
    }

    gpm {

    }
  }

  after :unpack do |result|
    Dir.chdir "#{package.workdir}/vim#{package.version.major}#{package.version.minor}"
  end

  after :dependencies do |result, deps|
    deps.delete_if {|d|
      d.name == 'python' && !d.slot
    }
  end

  # this fixes the configure, or it would be called during compile time
  before :configure do
    FileUtils.rm 'src/auto/configure'

    # TODO: write something in Ruby and not a sed call
    Packo.sh "sed -i 's/ auto.config.mk:/:/' src/Makefile"

    autotools.make '-j1', '-C', 'src', 'autoconf'
  end

  after :configure do |result, conf|
    autotools.configure conf
  end

  before :configure, 10 do |conf|
    conf.with 'modified-by', 'Distrø'

    conf.with 'tlib', 'curses'

    if !(features.gtk.enabled? || features.gnome.enabled?)
      conf.enable 'gui', 'no'
    end
  end
}

# Maintainer: meh. <meh@paranoici.org>

Package.define(['application', 'editor'], 'vim') {
  behavior Behaviors::GNU

  description 'Vim, an improved vi-style text editor'
  homepage    'http://www.vim.org/'
  license     'vim'

  source 'ftp://ftp.vim.org/pub/vim/unix/vim-#{package.version}.tar.bz2'

  features {
    ruby {
      on :configure do |conf|
        conf.enable 'rubyinterp', enabled?
      end
    }

    perl {
      on :configure do |conf|
        conf.enable 'perlinterp', enabled?
      end
    }

    mzscheme {
      on :configure do |conf|
        conf.enable 'mzschemeinterp', enabled?
      end
    }

    lua {
      on :configure do |conf|
        conf.enable 'luainterp', enabled?
      end
    }

    tcl {
      on :configure do |conf|
        conf.enable 'tclinterp', enabled?
      end
    }

    python {
      on :dependencies do |package|
        package.dependencies << 'development/interpreter/python%2'
      end

      on :configure do |conf|
        conf.enable 'pythoninterp', enabled?
      end
    }

    python3 {
      on :dependencies do |package|
        package.dependencies << 'development/interpreter/python%3'
      end

      on :configure do |conf|
        conf.enable 'python3interp', enabled?
      end
    }

    X {
      on :configure do |conf|
        conf.with 'x', enabled?
      end
    }

    gtk {
      needs 'X'

      on :configure do |conf|
        if enabled?
          conf.enable 'gtk2-check'
          conf.enable 'gui', 'gtk2'
        end
      end
    }

    gnome {
      needs 'X'

      on :configure do |conf|
        if enabled?
          conf.enable 'gtk2-check'
          conf.enable 'gui', 'gnome2'
        end
      end
    }

    netbeans {
      on :configure do |conf|
        conf.enable 'netbeans', enabled?
      end
    }

    cscope {
      on :dependencies do |package|
        package.dependencies << 'development/utility/cscope'
      end
    }

    gpm {

    }
  }

  on :unpacked do
    Dir.chdir "#{package.workdir}/vim#{package.version.major}#{package.version.minor}"
  end

  # this fixes the configure, or it would be called during compile time
  on :configure do
    FileUtils.rm 'src/auto/configure'

    # TODO: write something in Ruby and not a sed call
    Packo.sh "sed -i 's/ auto.config.mk:/:/' src/Makefile"

    autotools.make '-j1', '-C', 'src', 'autoconf'
  end

  on :configured do |conf|
    autotools.configure conf
  end

  on :configure, 10 do |conf|
    conf.with 'modified-by', 'Distrø'

    conf.with 'tlib', 'curses'

    if !(features.gtk.enabled? || features.gnome.enabled?)
      conf.enable 'gui', 'no'
    end
  end
}

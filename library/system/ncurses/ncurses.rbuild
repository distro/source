# Maintainer: meh. <meh@paranoici.org>

Package.define(['system', 'library', 'text'], 'ncurses') { type 'library'
  behavior Packo::Behaviors::GNU
  use      Packo::Modules::Fetching::GNU

  description 'console display library'
  homepage    'http://www.gnu.org/software/ncurses/', 'http://dickey.his.com/ncurses/'
  license     'MIT'

  source 'ncurses/#{package.version}'

  features {
    cxx { enabled!
      on :configure do |conf|
        conf.with ['cxx', 'cxx-binding'], enabled?
      end
    }

    unicode { enabled!
      on :unpacked do |file|
        next if !enabled?

        if !File.exists? "#{package.workdir}/ncursesw"
          FileUtils.cp_r "#{package.workdir}/ncurses-#{package.version}", "#{package.workdir}/ncursesw", :preserve => true
        end
      end

      on :compiled do |conf|
        next if !enabled?

        conf = conf.clone

        conf.enable 'widec'
        conf.set 'includedir', "#{package.distdir}/usr/include/ncursesw"

        Dir.chdir "#{package.workdir}/ncursesw"

        package.autotools.configure(conf)
        package.autotools.make(conf)

        Dir.chdir "#{package.workdir}/ncurses-#{package.version}"
      end

      on :installed do |conf|
        Dir.chdir "#{package.workdir}/ncursesw"

        package.autotools.install(package.distdir)
      end
    }

    gpm {
      on :dependencies do |package|
        package.dependencies << 'system/library/gpm' if enabled?
      end

      on :configure do |conf|
        conf.with 'gpm', enabled?
      end
    }

    ada {
      on :configure do |conf|
        conf.with 'ada', enabled?
      end
    }
  }

  on :configure do |conf|
    conf.with ['shared', 'rcs-ids']
    conf.with 'manpage-format', 'normal'
    conf.without 'hashed-db'

    conf.enable ['symlinks', 'const', 'colorfgbg', 'echo']

    # ABI compatibility
    conf.with 'chtype', 'long'
    conf.with 'mmask-t', 'long'
    conf.disable ['ext-colors', 'ext-mouse']
    conf.without ['pthread', 'reentrant']
  end

  on :compile do
    autotools.make '-j1', 'source'
  end
}

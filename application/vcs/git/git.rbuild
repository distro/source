Package.define('git') {
  tags 'application', 'vcs'

  description 'The stupid content tracker, the revision control system heavily used by the Linux kernel team'
  homepage    'http://www.git-scm.com/'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://www.kernel.org/pub/software/scm/git/git-#{package.version}.tar.bz2'

  features {
    http { enabled!
      description 'Enable git push/pull for HTTP and HTTPS'

      before :configure do |conf|
        package.arguments[:NO_CURL]  = 'YesPlease' if disabled?
        package.arguments[:NO_EXPAT] = 'YesPlease' if disabled?
      end
    }

    threads { enabled!
      before :configure do |conf|
        package.arguments[:THREADED_DELTA_SEARCH] = 'YesPlease' if enabled?
      end
    }

    ipv6 { enabled!
      before :configure do |conf|
        package.arguments[:NO_IPV6] = 'YesPlease' if disabled?
      end
    }

    cvs {
      before :configure do |conf|
        package.arguments[:NO_CVS] = 'YesPlease' if disabled?
      end
    }

    subversion {
      before :configure do |conf|
        package.arguments[:NO_SVN_TESTS] = 'YesPlease' if disabled?
      end
    }

    perl {
      before :configure do |conf|
        if enabled?
          package.arguments[:INSTALLDIRS] = 'vendor'
        else
          package.arguments[:NO_PERL] = 'YesPlease'
        end
      end
    }

    python {
      before :configure do |conf|
        package.arguments[:NO_PYTHON] = 'YesPlease' if disabled?
      end
    }

    tk {
      before :configure do |conf|
        package.arguments[:NO_TCLTK] = 'YesPlease' if disabled?
      end
    }
  }

  before :build do
    package.arguments = {
      :INSTALL    => 'install',
      :TAR        => 'tar',
      :SHELL_PATH => '/bin/sh',

      # Mac stuff
      :NO_FINK         => 'YesPlease',
      :NO_DARWIN_PORTS => 'YesPlease',

      # Misc stuff
      :SANE_TOOL_PATH               => '',
      :OLD_ICONV                    => '',
      :GIT_TEST_OPTS                => '--no-color',
      :NO_EXTERNAL_GREP             => '',
      :NO_CROSS_DIRECTORY_HARDLINKS => 'YesPlease',
      :DEFAULT_PAGER                => env[:PAGER],
      :DEFAULT_EDITOR               => env[:EDITOR],

      # Installation stuff
      :DESTDIR    => distdir,
      :prefix     => (env[:INSTALL_PATH] + 'usr').cleanpath,
      :htmldir    => (env[:INSTALL_PATH] + "usr/share/doc/git-#{package.version}").cleanpath,
      :sysconfdir => (env[:INSTALL_PATH] + 'etc').cleanpath,

      # Compilation stuff
      :OPTCFLAGS  => env[:CFLAGS],
      :OPTLDFLAGS => env[:LDFLAGS],
      :OPTCC      => env[:CC],
      :OPTAR      => env[:AR],

      # Language binding stuff
      :PYTHON_PATH => "#{(env[:INSTALL_PATH] + 'usr/bin/env').cleanpath} python",
      :PERL_PATH   => "#{(env[:INSTALL_PATH] + 'usr/bin/env').cleanpath} perl",
      :PERL_MM_OPT => ''
    }
  end

  before :configure do
    throw :halt
  end

  def make (*args)
    autotools.make *package.arguments.map {|(name, value)| "#{name}=#{value}"}, *args
  end

  before :compile do
    make

    throw :halt
  end

  before :install do
    make 'install'

    throw :halt
  end
}

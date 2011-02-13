Package.define('git') {
  tags 'application', 'vcs'

  description 'The stupid content tracker, the revision control system heavily used by the Linux kernel team'
  homepage    'http://www.git-scm.com/'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://www.kernel.org/pub/software/scm/git/git-#{package.version}.tar.bz2'

  features {
    curl {

    }

    threads {
      before :configure do |conf|
        package.arguments[:THREADED_DELTA_SEARCH] = 'YesPlease' if enabled?
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

  after :initialize do
    package.arguments = {
      :INSTALL    => 'install',
      :TAR        => 'tar',
      :SHELL_PATH => '/bin/sh',

      # Mac stuff
      :NO_FINK         => 'YesPlease',
      :NO_DARWIN_PORTS => 'YesPlease',

      # Misc stuff
      :SANE_TOOL_PATH   => '',
      :OLD_ICONV        => '',
      :NO_EXTERNAL_GREP => '',
    }
  end

  before :configure do
    throw :halt
  end

  def make (*args)
    autotools.make "DESTDIR=#{distdir}", "OPTCFLAGS=#{env[:CFLAGS]}", "OPTLDFLAGS=#{env[:LDFLAGS]}",
      "OPTCC=#{env[:CC]}", "OPTAR=#{env[:AR]}", "prefix=#{(env[:INSTALL_PATH] + '/usr').cleanpath}",
      "htmldir=#{(env[:INSTALL_PATH] + "/usr/share/doc/git-#{package.version}").cleanpath}",
      "sysconfdir=#{(env[:INSTALL_PATH] + '/etc').cleanpath}",
      "PYTHON_PATH=#{(env[:INSTALL_PATH] + '/usr/bin/env').cleanpath} python",
      "PERL_PATH=#{(env[:INSTALL_PATH] + '/usr/bin/env').cleanpath} perl",
      'PERL_MM_OPT=', 'GIT_TEST_OPTS=--no-color',
      *package.arguments.map {|(name, value)| "#{name}=#{value}"}, *args
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

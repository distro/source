Package.define('git') {
  behavior Behaviors::Standard

  tags 'application', 'vcs'

  maintainer 'meh. <meh@paranoici.org>'

  description 'GIT - the stupid content tracker, the revision control system heavily used by the Linux kernel team'
  homepage    'http://www.git-scm.com/'
  license     'GPL-2'

  source 'http://www.kernel.org/pub/software/scm/git/git-#{package.version}.tar.bz2'

  features {
    curl {

    }

    threads {
      before :configure do |conf|
        package.arguments[:THREADED_DELTA_SEARCH] = 'YesPlease'
      end
    }

    cvs {

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
}

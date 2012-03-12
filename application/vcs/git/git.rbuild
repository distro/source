maintainer 'meh. <meh@paranoici.org>'

name 'git'
tags 'application', 'vcs'

description 'The stupid content tracker, the revision control system heavily used by the Linux kernel team'
homepage    'http://www.git-scm.com/'
license     'GPL-2'

source 'https://git-core.googlecode.com/files/git-#{package.version}.tar.gz'

features {
	threads { enabled!
		before :configure do |conf|
			package.arguments[:THREADED_DELTA_SEARCH] = 'YesPlease' if enabled?
		end
	}

	sha1 { enabled!; default_value 'blk'
		before :configure do |conf|
			if value == 'blk'
				package.arguments[:BLK_SHA1] = 'YesPlease'
			elsif value == 'ppc'
				package.arguments[:PPC_SHA1] = 'YesPlease'
			end
		end
	}

	http { enabled!
		description 'Enable git push/pull for HTTP and HTTPS'

		before :configure do |conf|
			package.arguments[:NO_CURL]  = 'YesPlease' if disabled?
			package.arguments[:NO_EXPAT] = 'YesPlease' if disabled?
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

	perl { enabled!
		before :configure do |conf|
			if enabled?
				package.arguments[:INSTALLDIRS] = 'vendor'
				package.arguments[:USE_LIBPCRE] = 'YesPlease'
			else
				package.arguments[:NO_PERL] = 'YesPlease'
			end
		end
	}

	python { enabled!
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
		INSTALL:    'install',
		TAR:        'tar',
		SHELL_PATH: '/bin/sh',

		# Mac stuff
		NO_FINK:         'YesPlease',
		NO_DARWIN_PORTS: 'YesPlease',

		# Misc stuff
		SANE_TOOL_PATH:               '',
		OLD_ICONV:                    '',
		GIT_TEST_OPTS:                '--no-color',
		NO_EXTERNAL_GREP:             '',
		NO_CROSS_DIRECTORY_HARDLINKS: 'YesPlease',

		# Installation stuff
		DESTDIR:    distdir,
		prefix:     Path.clean(env[:INSTALL_PATH] + '/usr'),
		htmldir:    Path.clean(env[:INSTALL_PATH] + "/usr/share/doc/git-#{package.version}"),
		sysconfdir: Path.clean(env[:INSTALL_PATH] + '/etc'),
		gitexecdir: Path.clean(env[:INSTALL_PATH] + '/usr/lib/git-core'),

		# Compilation stuff
		OPTCFLAGS:  env[:CFLAGS],
		OPTLDFLAGS: env[:LDFLAGS],
		OPTCC:      env[:CC],
		OPTAR:      env[:AR],

		# Language binding stuff
		PYTHON_PATH: "#{Path.clean(env[:INSTALL_PATH] + '/usr/bin/env')} python",
		PERL_PATH:   "#{Path.clean(env[:INSTALL_PATH] + '/usr/bin/env')} perl",
		PERL_MM_OPT: ''
	}
end

def make (*args)
	autotools.make *package.arguments.map { |k, v| "#{k}=#{v}" }, *args, "-j#{env[:MAKE_JOBS]}"
end

before :configure do
	skip
end

before :compile do
	make

	skip
end

before :install do
	make 'install'

	skip
end

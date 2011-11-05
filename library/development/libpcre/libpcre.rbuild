maintainer 'meh. <meh@paranoici.org>'

name 'libpcre'
tags 'library', 'development'

description 'Perl-Compatible Regular Expression library'
homepage    'http://www.pcre.org'
licene      'BSD'

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
	cxx { enabled!
		before :configure do |conf|
			conf.enable 'cpp', enabled?
		end
	}

	unicode { enabled!
		before :configure do |conf|
			conf.enable 'utf8', enabled?
			conf.enable 'unicode-properties', enabled?
		end
	}

	zlib {
		describe 'Add zlib support to pcregrep'

		before :configure do |conf|
			conf.enable 'pcregrep-zlib', enabled?
		end
	}

	bzip2 {
		describe 'Add bzip2 support to pcregrep'

		before :configure do |conf|
			conf.enable 'pcregrep-libbz2', enabled?
		end
	}
}

maintainer 'meh. <meh@paranoici.org>'

name 'pcre'
tags 'library', 'development'

description 'Perl-Compatible Regular Expression library'
homepage    'http://www.pcre.org'
license     'BSD'

source 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-#{version}.tar.bz2'

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
	bits { enabled!; default_value '8,16'
		before :configure do |conf|
			next unless enabled?

			conf.enable 'pcre8', value.split(',').include?('8')
			conf.enable 'pcre16', value.split(',').include?('16')
		end
	}

	recursion_limit { enabled!; default_value '8192'
		before :configure do |conf|
			conf.with 'match-limit-recursion', value if enabled?
		end
	}

	unicode { enabled!
		before :configure do |conf|
			conf.enable 'utf', enabled?
			conf.enable 'unicode-properties', enabled?
		end
	}

	jit { enabled!
		before :configure do |conf|
			conf.enable 'jit', enabled?
			conf.enable 'pcregrep-jit', enabled?
		end
	}

	cxx { enabled!
		before :configure do |conf|
			conf.enable 'cpp', enabled?
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

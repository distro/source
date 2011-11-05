maintainer 'meh. <meh@paranoici.org>'

type 'libc'

name 'glibc'
tags 'library', 'system', 'libc', 'gnu'

description 'GNU libc6 (also called glibc2) C library'
homepage    'http://www.gnu.org/software/libc/libc.html'
license     'GPL', 'LGPL'

source 'gnu://glibc/#{version}'

flavor {
	multilib {
		before :configure do |conf|
			conf.enable 'multilib', enabled?
		end
	}

	hardened {
		before :configure do |conf|
			conf.enable 'stackguard-randomization', enabled?
		end
	}
}

features {
	nls {
		before :configure do |conf|
			conf.disable 'nls' if disabled?
		end
	}
}

before :configure do |conf|
	env[:CXXFLAGS] = env[:CFLAGS] = '-O2 -fno-strict-aliasing -pipe'

	Do.dir "#{workdir}/build"
	Do.cd  "#{workdir}/build"

	conf.path = "#{workdir}/glibc-#{package.version}/configure"

	conf.with 'headers', "/usr/include"

	conf.enable  ['bind-now']
	conf.disable ['profile', 'multi-arch']
	conf.with    ['__thred', 'tls']
	conf.without ['cvs', 'gd']
end

before :compile do
	autotools.make

	skip
end

maintainer 'meh. <meh@paranoici.org>'

use Fetching::Subversion, Building::Scons

name 'v8'
tags 'application', 'interpreter', 'development', 'javascript', 'embeddable', 'google'

description "Google's open source JavaScript engine"
homepage    'http://code.google.com/p/v8'
license     'BSD'

source Location[
	repository: 'http://v8.googlecode.com/svn',
	tag:        '#{version}'
]

flavor {
	debug {
		before :configure do |conf|
			conf.set 'mode', enabled? ? 'debug' : 'release'
		end
	}
}

features {
	self.set('readline') {
		before :configure do |conf|
			conf.set 'console', 'readline' if enabled?
		end
	}
}

before :patch do
	Do.sed 'SConstruct', ["'-Werror',", '']
end

before :configure do |conf|
	env[:LINKFLAGS] = env[:LDFLAGS]

	case package.target
		when 'i?86-*'   then conf.set 'arch', 'ia32'
		when 'x86_64-*' then conf.set 'arch', 'x64'
		when 'arm*-*'   then conf.set 'arch', 'arm'
		else raise ArgumentError, 'v8 is not compatible with this arch'
	end

	conf.enable 'soname'

	conf.set 'library',    'shared'
	conf.set 'sample',     'shell'
	conf.set 'visibility', 'default'
	conf.set 'importenv',  'LINKFLAGS,PATH'
end

after :install do
	package.do.into '/usr/include' do
		package.do.ins 'include/*.h'
	end

	package.do.lib "libv8-#{package.version}.so"
	package.do.sym "libv8-#{package.version}.so", '/usr/lib/libv8.so'

	package.do.into '/usr' do
		package.do.bin ['shell', 'v8-shell']
	end
end

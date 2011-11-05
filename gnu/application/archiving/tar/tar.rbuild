maintainer 'meh. <meh@paranoici.org>'

name 'tar'
tags 'applicaton', 'archive', 'gnu'

description 'Utility used to store, backup, and transport files'
homepage    'http://www.gnu.org/software/tar/'
license     'GPL-3'

source 'gnu://tar/#{version}'

flavor {
	static {
		description 'Build a statically linked version of tar'

		before :configure do
			environment[:CFLAGS] << '-static' if enabled?
		end
	}
}

features {
	nls {
		before :configure do |conf|
			conf.enable 'nls', enabled?
		end
	}
}

before :configure do |conf|
	conf.enable 'backup-scripts'

	environment[:FORCE_UNSAFE_CONFIGURE] = true
end

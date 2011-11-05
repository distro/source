maintainer  'shura <shura1991@gmail.com>'

name 'libffi'
tags 'library', 'development'

description 'A portable, high level programming interface to various calling conventions.'
homepage    'http://sourceware.org/libffi/'
license     'MIT'

source 'ftp://sourceware.org/pub/libffi/libffi-#{version.gsub(\'_\', \'\')}.tar.gz'

flavor {
	static {
		before :configure do |conf|
			conf.enable 'static' if enabled?
		end
	}

	debug {
		before :configure do |conf|
			conf.enable 'debug' if enabled?
		end
	}
}

after :unpack do
	Do.cd "#{package.workdir}/libffi-#{package.version.to_s.gsub('_', '')}"
end

before :configure do |conf|
	if System.has?('coreutils') && System.has?('coreutils').tags.include?('bsd')
		env[:HOST] = env[:CHOST]
	end

	conf.enable 'dependency-tracking'
end

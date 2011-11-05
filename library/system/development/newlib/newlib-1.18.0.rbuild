arch     '~x86', '~amd64'
kernel   'linux'
compiler 'gcc'

features {
	iconv {
		before :configure do |conf|
			conf.enable 'newlib-iconv', enabled?
		end
	}
}

after :unpack do
	Dir.chdir "#{package.workdir}/newlib-#{package.version}/newlib"
end

version '1.8.5'

arch     'x86', 'x86_64'
kernel   'linux'
compiler 'gcc'
libc     'glibc'

source 'http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz'

before :pack do
	package.do.into '/usr/lib' do
		package.do.sym 'libmozjs185.so.1.0.0', 'libmozjs185.so.1.0'
		package.do.sym 'libmozjs185.so.1.0', 'libmozjs185.so'
	end

	Do

	Do.sed "#{distdir}/usr/bin/js-config",
		['-Wl,--whole-archive ctypes/libffi/.libs/libffi.a  -Wl,--no-whole-archive', '']
end

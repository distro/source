maintainer 'meh. <meh@paranoici.org>'

name 'openssl'
tags  'library', 'development', 'network'

description 'full-strength general purpose cryptography library (including SSL v2/v3 and TLS v1)'
homepage    'http://www.openssl.org/'
license     'openssl'

source 'ftp://ftp.openssl.org/source/openssl-#{version}.tar.gz',
	['http://cvs.pld-linux.org/cgi-bin/cvsweb.cgi/~checkout~/packages/openssl/openssl-c_rehash.sh?rev=#{rev}', 'c_rehash']

after :unpack do
	Do.cp "#{fetchdir}/c_rehash", "#{workdir}/c_rehash"
end

before :configure do

end

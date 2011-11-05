arch     'x86', 'x86_64'
kernel   'linux'
compiler 'gcc'
libc     'glibc'

use Fetching::Mercurial

source Location[
	repository: 'https://gpsee.googlecode.com/hg/'
]

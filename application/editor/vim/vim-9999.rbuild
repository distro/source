arch     '~x86', '~amd64'
kernel   'linux'
compiler 'gcc'
libc     'glibc'

autotools.version :autoconf, '2.6'

use Fetching::Mercurial

source Location[
	repository: 'https://vim.googlecode.com/hg/'
]

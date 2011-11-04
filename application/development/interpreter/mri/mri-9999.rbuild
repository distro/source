version '9999'
slot    '1.9'

arch     '~x86', '~x86_64'
kernel   'linux'
compiler 'gcc'
libc     'glibc'

use Fetching::Subversion

source Location[
	repository: 'http://svn.ruby-lang.org/repos/ruby/'
]

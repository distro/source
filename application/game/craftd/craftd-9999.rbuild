arch     '~x86', '~x86_64'
kernel   'linux'
compiler 'gcc', 'clang'
libc     'glibc'

use Fetching::Git

source Location[
	repository: 'git://github.com/craftd/craftd.git'
]

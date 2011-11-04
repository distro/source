version '9999'

arch     'x86', 'x86_64'
kernel   'linux', 'darwin'
libc     'glibc'
compiler 'gcc', 'clang'

use Fetching::Git

source Location[
	repository: 'git://github.com/rubinius/rubinius.git'
]

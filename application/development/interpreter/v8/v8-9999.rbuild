version '9999'

arch     'x86', 'x86_64', 'arm'
kernel   'linux'
compiler 'gcc'
libc     'glibc'

source.delete(:tag)
source.branch = :bleeding_edge

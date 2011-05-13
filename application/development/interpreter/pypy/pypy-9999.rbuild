Package.define('pypy', '9999') {
  arch     '~x86', '~x86_64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'

  use Fetching::Mercurial

  source Location[
    repository: 'http://bitbucket.org/pypy/pypy'
  ]
}

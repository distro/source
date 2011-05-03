Package.define('minutor', '9999') {
  arch     '~x86', '~x86_64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'

  use Fetching::Mercurial

  mercurial(
    repository: 'http://seancode.com/hg/minutor'
  )
}

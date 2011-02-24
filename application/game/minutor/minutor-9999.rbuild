Package.define('minutor', '9999') {
  arch     '~x86', '~x86_64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'

  use Modules::Misc::Fetching::Mercurial

  source 'http://seancode.com/hg/minutor'
}

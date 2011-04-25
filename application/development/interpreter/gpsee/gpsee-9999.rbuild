Package.define('gpsee', '9999') {
  arch     'x86', 'x86_64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'

  use Modules::Misc::Fetching::Mercurial

  source 'https://gpsee.googlecode.com/hg/'
}

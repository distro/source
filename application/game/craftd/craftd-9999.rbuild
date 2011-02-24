Package.define('craftd', '9999') {
  arch     '~x86', '~x86_64'
  kernel   'linux'
  compiler 'gcc', 'clang'
  libc     'glibc'

  use Modules::Misc::Fetching::Git

  source 'git://github.com/kev009/craftd.git'
}

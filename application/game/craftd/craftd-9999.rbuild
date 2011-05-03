Package.define('craftd', '9999') {
  arch     '~x86', '~x86_64'
  kernel   'linux'
  compiler 'gcc', 'clang'
  libc     'glibc'

  use Fetching::Git

  git(
    repository: 'git://github.com/craftd/craftd.git'
  )
}

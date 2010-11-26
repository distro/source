# Maintainer: meh. <meh@paranoici.org>

Package.define(['application', 'compiler', 'system', 'development'], 'gcc', '4.5.1', '4.5') {
  arch     'x86', 'amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'
}

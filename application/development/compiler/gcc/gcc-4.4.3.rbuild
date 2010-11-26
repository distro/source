# Maintainer: meh. <meh@paranoici.org>

Package.define(['application', 'compiler', 'system', 'development'], 'gcc', '4.4.3', '4.4') {
  arch     'x86', 'amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'
}

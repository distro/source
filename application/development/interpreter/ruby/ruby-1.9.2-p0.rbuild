# Maintainer: meh. <meh@paranoici.org>

Package.define(['application', 'interpreter', 'development'], 'ruby', '1.9.2-p0', '1.9') {
  arch     '~x86', '~amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'
}

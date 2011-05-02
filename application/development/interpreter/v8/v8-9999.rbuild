Package.define('v8', '9999') {
  arch     'x86', 'x86_64', 'arm'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'

  subversion.merge!(
    tag:    nil,
    branch: :bleeding_edge
  )
}

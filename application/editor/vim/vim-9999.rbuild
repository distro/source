Package.define('vim', '9999') {
  arch     '~x86', '~amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'

  autotools.version :autoconf, '2.6'

	use Modules::Misc::Fetching::Mercurial

	source 'https://vim.googlecode.com/hg/'
}

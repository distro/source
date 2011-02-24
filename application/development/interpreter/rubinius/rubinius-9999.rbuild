Package.define('rubinius', '9999') {
  arch     'x86', 'x86_64'
  kernel   'linux', 'darwin'
  libc     'glibc'
  compiler 'gcc', 'clang'

  use Modules::Misc::Fetching::Git

  source 'git://github.com/evanphx/rubinius.git'

  flavor {
    hydra {
      description 'Enable the hydra branch, deletetion of GIL in progress'

      before :fetch do
        source 'git://github.com/evanphx/rubinius.git:hydra' if enabled?
      end
    }
  }
}

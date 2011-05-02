Package.define('rubinius', '9999') {
  arch     'x86', 'x86_64'
  kernel   'linux', 'darwin'
  libc     'glibc'
  compiler 'gcc', 'clang'

  use Modules::Misc::Fetching::Git

  git {
    repository: 'git://github.com/evanphx/rubinius.git'
  }

  flavor {
    hydra {
      description 'Enable the hydra branch, deletetion of GIL in progress'

      before :fetch do
        git[:branch] = 'hydra' if enabled?
      end
    }
  }
}

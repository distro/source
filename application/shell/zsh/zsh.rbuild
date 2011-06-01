Package.define('zsh') {
  tags 'application', 'shell'

  description 'A very advanced and programmable command interpreter (shell) for UNIX'
  homepage    'http://www.zsh.org/'
  license     'ZSH'

  maintainer 'meh. <meh@paranoici.org>'

  source 'ftp://ftp.zsh.org/pub/zsh-#{version}.tar.bz2'

  dependencies << 'library/system/ncurses[unicode]'

  features {
    mail {
      description 'Add support for maildir'

      before :configure do |conf|
        conf.enable 'maildir', enabled?
      end
    }

    cap {
      before :configure do |conf|
        conf.enable 'cap', enabled?
      end
    }
  }

  before :configure do |conf|
    conf.set 'prefix', (env[:INSTALL_PATH] + '/usr').cleanpath
    conf.set 'bindir', (env[:INSTALL_PATH] + '/bin').cleanpath

    conf.enable 'etcdir',   (env[:INSTALL_PATH] + '/etc/zsh').cleanpath
    conf.enable 'zshenv',   (env[:INSTALL_PATH] + '/etc/zsh/zshenv').cleanpath
    conf.enable 'zlogin',   (env[:INSTALL_PATH] + '/etc/zsh/zlogin').cleanpath
    conf.enable 'zlogout',  (env[:INSTALL_PATH] + '/etc/zsh/zlogout').cleanpath
    conf.enable 'zprofile', (env[:INSTALL_PATH] + '/etc/profile').cleanpath
    conf.enable 'zshrc',    (env[:INSTALL_PATH] + '/etc/zsh/zshrc').cleanpath

    conf.enable  ['multibyte', 'function-subdirs', 'pcre', 'zsh-secure-free']
    conf.disable ['gdbm']

    conf.with 'term-lib', 'ncursesw'
    conf.with 'tcsetpgrp'
  end
}

# Maintainer: meh. <meh@paranoici.org>

require 'packo/behaviors/gnu'

Packo::Package.new('applications/editors/vim') {
  behavior Packo::Behaviors::GNU

  description 'Vim, an improved vi-style text editor'
  homepage    'http://www.vim.org/'
  license     'vim'

  source 'ftp://ftp.vim.org/pub/vim/unix/vim-#{package.version}.tar.bz2'
}

Package.define('pdcurses') {
  tags 'library', 'x11'

  description 'A public domain curses library for DOS, OS/2, Win32, X11'
  homepage    'http://pdcurses.sourceforge.net/'
  license     'MIT public-domain'

  maintainer 'meh. <meh@paranoici.org>'

  source 'sourceforge://pdcurses/pdcurses/#{package.version}/PDCurses-#{package.version}'
}

Package.define('firefox') {
  tags 'application', 'network', 'web', 'browser'

  description 'Firefox Web Browser'
  homepage    'http://www.mozilla.com/firefox'
  license     'MPL-1.1', 'GPL-2', 'LGPL-2.1'

  maintainer 'meh. <meh@paranoici.org>'

  source 'ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/#{package.version}/source/firefox-#{package.version}.tar.bz2'
}

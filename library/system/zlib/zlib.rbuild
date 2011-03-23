Package.define('zlib') {
  type 'library'
  tags 'library', 'system', 'compression'

  description 'Standard (de)compression library'
  homepage    'http://www.zlib.net/'
  license     'ZLIB'

  maintainer  'shura <shura1991@gmail.com>'

  source      'http://zlib.net/zlib-#{package.version}.tar.gz'

  after :configure do
    base = (System.env[:INSTALL_PATH] + '/usr').cleanpath
    Packo.sh './configure', '--shared', "--prefix=#{base}", "--libdir=#{base + '/lib'}"

    throw :halt
  end
}

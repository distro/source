Package.define('installwatch') {
  tags 'application', 'system'

  description 'Installwatch is an extremely simple utility to keep track of created and modified files during the installation of a new program.'
  homepage    'http://asic-linux.com.mx/~izto/checkinstall/installwatch.html'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  before :configure do |conf|
    env[:PREFIX] = (env[:INSTALL_PATH] + '/usr').cleanpath

    skip
  end
}

Package.define('minutor') {
  tags 'application', 'game', 'utility', 'minecraft', 'viewer'

  description 'Minutor is a simple mapping tool for minecraft. Its quickness, portability, and inspection features make it unique.'
  homepage    'http://seancode.com/minutor/'
  license     

  source 'http://seancode.com/minutor/#{package.version.major}.#{package.version.minor}/minutor_#{package.version}.tar.gz'

  after :unpack do
    Do.cd "#{workdir}/minutor"
  end

  before :configure do
    skip
  end
}

Package.define('autoconf') {
  behavior Behaviors::GNU
  use      Modules::Fetching::GNU

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'system', 'development', 'utility'

  description 'Used to create autoconfiguration files'
  homepage    'http://www.gnu.org/software/autoconf/autoconf.html'
  license     'GPL-2'

  source 'autoconf/#{package.version}'

  dependencies << 'development/interpreter/perl!'

  before :configure do |conf|
    ENV['EMACS'] = 'no'
    
    conf.set 'program-suffix', "-#{package.version}"
  end

  before :compile do
    package.environment[:MAKE_JOBS] = 1
  end

  before :pack do
    package.slot = package.version
  end
}

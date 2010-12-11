Package.define('fakeroot') {
  tags 'application', 'system'
  
  description 'Run commands in an environment faking root privileges'
  homepage    'http://packages.qa.debian.org/f/fakeroot.html'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  before :configure do
    environment[:CONFIG_SHELL] = '/bin/sh'
  end
}

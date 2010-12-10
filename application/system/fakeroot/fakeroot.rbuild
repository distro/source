Package.define('fakeroot') {
  behavior Behaviors::Standard

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'system'
  
  description 'Run commands in an environment faking root privileges'
  homepage    'http://packages.qa.debian.org/f/fakeroot.html'
  license     'GPL-2'

  before :configure do
    environment[:CONFIG_SHELL] = '/bin/sh'
  end
}

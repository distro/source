Package.define('ecl') {
  tags 'application', 'interpreter', 'development', 'lisp', 'embeddable'

  description 'ECL is an implementation of the Common Lisp language as defined by the ANSI X3J13 specification.'
  homepage    'http://ecls.sourceforge.net/'
  license     'LGPL-2+'

  maintainer 'meh. <meh@paranoici.org>'

  source 'sourceforge://ecls/ecls/#{package.version.major}.#{package.version.minor}/ecl-#{package.version}'

  features {
    threads { enabled!
      before :configure do |conf|
        conf.enable 'threads', enabled?
      end
    }
  }

  before :compile do |conf|
    autotools.make

    throw :halt
  end
}

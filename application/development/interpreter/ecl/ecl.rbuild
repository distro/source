maintainer 'meh. <meh@paranoici.org>'

name 'ecl'
tags 'application', 'interpreter', 'development', 'lisp', 'embeddable'

description 'ECL is an implementation of the Common Lisp language as defined by the ANSI X3J13 specification.'
homepage    'http://ecls.sourceforge.net/'
license     'LGPL-2+'

source 'sourceforge://ecls/ecls/#{version.major}.#{version.minor}/ecl-#{version}'

features {
	threads { enabled!
		before :configure do |conf|
			conf.enable 'threads', enabled?
		end
	}

	unicode { enabled!
		before :configure do |conf|
			conf.enable 'unicode', enabled?
		end
	}
}

before :compile do |conf|
	autotools.make

	skip
end

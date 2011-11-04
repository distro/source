maintainer 'meh. <meh@paranoici.org>'

name 'lisp'
tags 'application', 'development', 'interpreter', 'virtual'

description 'Virtual package for LISP interpreters'

features {
	ecl {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/lisp/ecl' if enabled?
		end
	}

	sbcl {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/lisp/sbcl' if enabled?
		end
	}
}

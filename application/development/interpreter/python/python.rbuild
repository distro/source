maintainer 'meh. <meh@paranoici.org>'

name 'python'
tags 'application', 'development', 'interpreter', 'virtual'

description 'Virtual package for Python interpreters'

features {
	set('cpython2.4') {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/python/cpython%2.4' if enabled?
		end
	}

	set('cpython2.5') {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/python/cpython%2.5' if enabled?
		end
	}

	set('cpython2.6') {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/python/cpython%2.6' if enabled?
		end
	}

	set('cpython2.7') {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/python/cpython%2.7' if enabled?
		end
	}

	set('cpython3.1') {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/python/cpython%3.1' if enabled?
		end
	}

	jython {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/python/jython' if enabled?
		end
	}

	pypy {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/python/pypy' if enabled?
		end
	}
}

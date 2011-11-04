maintainer 'meh. <meh@paranoici.org>'

name 'javascript'
tags 'application', 'development', 'interpreter', 'virtual'

description 'Virtual package for JavaScript interpreters'

features {
	spidermonkey {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/javascript/spidermonkey' if enabled?
		end
	}

	v8 {
		before :dependencies do |deps|
			deps << 'application/interpreter/development/javascript/v8' if enabled?
		end
	}
}

Package.define('python') {
  tags 'application', 'development', 'interpreter', 'virtual'

  description 'Virtual package for Python interpreters'

  maintainer 'meh. <meh@paranoici.org>'

  features {
    self.set('cpython2.4') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/python/cpython%2.4' if enabled?
      end
    }

    self.set('cpython2.5') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/python/cpython%2.5' if enabled?
      end
    }

    self.set('cpython2.6') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/python/cpython%2.6' if enabled?
      end
    }

    self.set('cpython2.7') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/python/cpython%2.7' if enabled?
      end
    }

    self.set('cpython3.1') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/python/cpython%3.1' if enabled?
      end
    }

    self.set('jython') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/python/jython' if enabled?
      end
    }

    self.set('pypy') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/python/pypy' if enabled?
      end
    }
  }
}

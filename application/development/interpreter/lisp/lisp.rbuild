Package.define('lisp') {
  tags 'application', 'development', 'interpreter', 'virtual'

  description 'Virtual package for LISP interpreters'

  maintainer 'meh. <meh@paranoici.org>'

  features {
    self.set('ecl') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/lisp/ecl' if enabled?
      end
    }

    self.set('sbcl') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/lisp/sbcl' if enabled?
      end
    }
  }
}

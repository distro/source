Package.define('ruby') {
  tags 'application', 'development', 'interpreter', 'virtual'

  description 'Virtual package for Ruby interpreters'

  maintainer 'meh. <meh@paranoici.org>'

  features {
    self.set('mri1.8') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/ruby/mri%1.8' if enabled?
      end
    }

    self.set('mri1.9') { enabled!
      before :dependencies do |deps|
        deps << 'application/interpreter/development/ruby/mri%1.9' if enabled?
      end
    }

    self.set('rubinius') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/ruby/rubinius' if enabled?
      end
    }

    self.set('jruby') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/ruby/jruby' if enabled?
      end
    }
  }
}

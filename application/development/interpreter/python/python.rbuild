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

__END__
$$$

$$$ selectors/select-python.rb $$$

#! /usr/bin/env python
require 'packo'
require 'packo/models'

class Application < Thor
  include Packo

  class_option :help, :type => :boolean, :desc => 'Show help usage'

  desc 'list', 'List available Python versions'
  def list
    CLI.info 'List of availaibale Python versions'

    self.versions.each_with_index {|version, i|
      puts (self.current == version) ?
        "  {#{(i + 1).to_s.green}}    #{version}" :
        "  [#{i + 1             }]    #{version}"
    }
  end

  desc "set VERSION", 'Choose what version of Python to use'
  def set (version)
    versions = self.versions

    if version.numeric? && (version.to_i > versions.length || version.to_i < 1)
      fatal "#{version} out of index"
      exit 1
    end

    if version.numeric?
      version = versions[version.to_i - 1]
    end

    if !versions.member? version
      fatal "#{version} version not available for #{target}"
      exit 2
    end

    case version
    end

    CLI.info "Set Python to #{version}"

    Models::Selector.first(:name => 'python').update(:data => version)
  end

  no_tasks {
    def current
      Models::Selector.first(:name => 'python').data rescue nil
    end
  
    def versions
      versions = []

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/python1.8")
      end

      versions
    end
  }
end

Application.start(ARGV)

# python: Set the Python version to use

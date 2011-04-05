Package.define('javascript') {
  tags 'application', 'development', 'interpreter', 'virtual'

  description 'Virtual package for JavaScript interpreters'

  maintainer 'meh. <meh@paranoici.org>'

  features {
    self.set('spidermonkey') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/javascript/spidermonkey' if enabled?
      end
    }

    self.set('v8') {
      before :dependencies do |deps|
        deps << 'application/interpreter/development/javascript/v8' if enabled?
      end
    }
  }
}

__END__
$$$

$$$ selectors/select-javascript.rb $$$

#! /usr/bin/env javascript
require 'packo'
require 'packo/models'

class Application < Thor
  include Packo

  class_option :help, :type => :boolean, :desc => 'Show help usage'

  desc 'list', 'List available JavaScript versions'
  def list
    CLI.info 'List of availaibale JavaScript versions'

    self.versions.each_with_index {|version, i|
      puts (self.current == version) ?
        "  {#{(i + 1).to_s.green}}    #{version}" :
        "  [#{i + 1             }]    #{version}"
    }
  end

  desc "set VERSION", 'Choose what version of JavaScript to use'
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
      when 'ecl'

      when 'sbcl'
    end

    CLI.info "Set JavaScript to #{version}"

    Models::Selector.first(:name => 'javascript').update(:data => version)
  end

  no_tasks {
    def current
      Models::Selector.first(:name => 'javascript').data rescue nil
    end
  
    def versions
      versions = []

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/ecl")
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/sbcl")
      end

      versions
    end
  }
end

Application.start(ARGV)

# javascript: Set the JavaScript version to use

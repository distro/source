Package.define('ruby') {
  tags 'application', 'development', 'interpreter', 'virtual'

  avoid Behaviors::Default

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

__END__
$$$

$$$ selectors/select-ruby.rb $$$

#! /usr/bin/env ruby
require 'packo'
require 'packo/models'

class Application < Thor
  include Packo

  class_option :help, :type => :boolean, :desc => 'Show help usage'

  desc 'list', 'List available Ruby versions'
  def list
    CLI.info 'List of availaibale Ruby versions'

    self.versions.each_with_index {|version, i|
      puts (self.current == version) ?
        "  {#{(i + 1).to_s.green}}    #{version}" :
        "  [#{i + 1             }]    #{version}"
    }
  end

  desc "set VERSION", 'Choose what version of Ruby to use'
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

    files = [:erb, :gem, :irb, :rake, :rdoc, :ri, :ruby, :testrb]

    case version
      when 'mri-1.8'
        files.each {|file|
          FileUtils.ln_sf "#{System.env![:INSTALL_PATH]}/usr/bin/#{file}1.8", "#{System.env![:INSTALL_PATH]}/usr/bin/#{file}" rescue nil
        }

      when 'mri-1.9'
        files.each {|file|
          FileUtils.ln_sf "#{System.env![:INSTALL_PATH]}/usr/bin/#{file}1.9", "#{System.env![:INSTALL_PATH]}/usr/bin/#{file}" rescue nil
        }

      when 'jruby'
        files.each {|file|
          FileUtils.ln_sf "#{System.env![:INSTALL_PATH]}/usr/bin/j#{file}", "#{System.env![:INSTALL_PATH]}/usr/bin/#{file}" rescue nil
        }

      when 'rubinius'
        files.each {|file|
          FileUtils.ln_sf "#{System.env![:INSTALL_PATH]}/usr/bin/rbx", "#{System.env![:INSTALL_PATH]}/usr/bin/#{file}" rescue nil
        }        
    end

    CLI.info "Set Ruby to #{version}"

    Models::Selector.first(:name => 'ruby').update(:data => version)
  end

  no_tasks {
    def current
      Models::Selector.first(:name => 'ruby').data rescue nil
    end
  
    def versions
      versions = []

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/ruby1.8")
        versions << 'mri-1.8'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/ruby1.9")
        versions << 'mri-1.9'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/jruby")
        versions << 'jruby'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/rbx")
        versions << 'rubinius'
      end

      versions
    end
  }
end

Application.start(ARGV)

# ruby: Set the Ruby version to use

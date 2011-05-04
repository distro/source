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

$$$ selectors/select-pythonrb $$$

#! /usr/bin/env ruby
require 'packo'
require 'packo/cli'
require 'packo/models'

class Application < Thor
  include Packo

  class_option :help, :type => :boolean, :desc => 'Show help usage'

  desc 'list', 'List available Python versions'
  def list
    CLI.info 'List of availaibale Python versions'

    current = self.current

    self.versions.each {|target, versions|
      next if versions.empty?

      if target == 'default'
        name = 'Default Python'
      else
        name = "Python #{target}"
      end

      puts ''
      puts name.blue.bold

      versions.each_with_index {|version, i|
        puts (current[target] == version) ?
          "  {#{(i + 1).to_s.green}}    #{version}" :
          "  [#{i + 1             }]    #{version}"
      }
    }
  end

  desc "set VERSION [TARGET=default]", 'Choose what version of Python to use'
  def set (version, target=:default)
    target   = normalize(target)
    versions = self.versions[target]

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

    place = case target
      when 'default' then 'python'
      when '2'       then 'python2'
      when '3'       then 'python3'
    end

    case version
      when 'cpython-2.4'
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/python2.4").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{place}").cleanpath) rescue nil

      when 'cpython-2.5'
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/python2.5").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{place}").cleanpath) rescue nil

      when 'cpython-2.6'
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/python2.6").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{place}").cleanpath) rescue nil

      when 'cpython-2.7'
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/python2.7").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{place}").cleanpath) rescue nil

      when 'cpython-3.0'
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/python3.0").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{place}").cleanpath) rescue nil

      when 'cpython-3.1'
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/python3.1").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{place}").cleanpath) rescue nil

      when 'cpython-3.2'
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/python3.2").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{place}").cleanpath) rescue nil

      when 'pypy'
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/pypy").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{place}").cleanpath) rescue nil
    end

    CLI.info "Set Python to #{version}"

    Models::Selector.first(:name => 'python').update(:data => self.current.merge(target => version))
  end

  no_tasks {
    def current
      (Models::Selector.first(:name => 'python').data rescue nil) || {}
    end
  
    def versions
      versions = { ?2 => [], ?3 => [] }

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/python2.4")
        versions[?2] << 'cpython-2.4'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/python2.5")
        versions[?2] << 'cpython-2.5'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/python2.6")
        versions[?2] << 'cpython-2.6'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/python2.7")
        versions[?2] << 'cpython-2.7'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/python3.0")
        versions[?3] << 'cpython-3.0'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/python3.1")
        versions[?3] << 'cpython-3.1'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/python3.2")
        versions[?3] << 'cpython-3.2'
      end

      if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/pypy")
        versions[?2] << 'pypy'
      end

      versions['default'] = versions[?2] + versions[?3]

      versions
    end

    def normalize (target)
      target = target.to_s

      if target.match(/2/)
        '2'
      elsif target.to_s.match(/3/)
        '3'
      else
        'default'
      end
    end
  }
end

Application.start(ARGV)

# python: Set the Python version to use

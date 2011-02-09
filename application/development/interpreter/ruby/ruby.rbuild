Package.define('ruby') {
  tags 'application', 'development', 'interpreter', 'ruby', 'virtual'
}

__END__
$$$

$$$ selectors/select-ruby.rb $$$

>>> /usr/bin/erb1.9
>>> /usr/bin/gem1.9
>>> /usr/bin/irb1.9
>>> /usr/bin/rake1.9
>>> /usr/bin/rdoc1.9
>>> /usr/bin/ri1.9
>>> /usr/bin/ruby1.9
>>> /usr/bin/testrb1.9


#! /usr/bin/env ruby
require 'packo'
require 'packo/models'

class Application < Thor
  include Packo

  class_option :help, :type => :boolean, :desc => 'Show help usage'

  desc 'list', 'List available Ruby versions'
  def list
    CLI.info 'List of availaibale Ruby versions'

    current = self.current

    self.versions.each {|version|
      puts ''
      puts target.blue.bold

      versions.each_with_index {|version, i|
        puts (current[target] == version) ?
          "  {#{(i + 1).to_s.green}}    #{version}" :
          "  [#{i + 1             }]    #{version}"
      }
    }
  end

  desc "set VERSION [TARGET=#{System.host}]", 'Choose what version of gcc to use'
  def set (version, target=System.host.to_s)
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

    if target == System.host.to_s
      FileUtils.ln_sf Dir.glob("/usr/#{System.host}/gcc-bin/#{version}/*"), '/usr/bin'
    else
      FileUtils.ln_sf Dir.glob("/usr/#{System.host}/#{target}/gcc-bin/#{version}/#{target}-*"), '/usr/bin/'
    end

    CLI.info "Set gcc to #{version} for #{target}"

    Models::Selector.first(:name => 'gcc').update(:data => self.current.merge(target => version))
  end

  no_tasks {
    def current
      Models::Selector.first(:name => 'ruby').data rescue nil
    end
  
    def versions
      Dir.glob('/usr/bin/ruby?*').map {|path|
        path.sub('/usr/bin/ruby', '')
      }
    end
  }
end

Application.start(ARGV)

# ruby: Set the Ruby version to use

#! /usr/bin/env ruby
require 'packo'
require 'packo/cli'
require 'packo/models'

class Application < Thor
  include Packo

  class_option :help, :type => :boolean, :desc => 'Show help usage'

  desc 'list', 'List available GCC versions'
  def list
    CLI.info 'List of availaibale GCC versions'

    current = self.current

    self.versions.each {|target, versions|
      next if versions.empty?

      puts ''
      puts target.blue.bold

      versions.each_with_index {|version, i|
        puts (current[target] == version) ?
          "  {#{(i + 1).to_s.green}}    #{version}" :
          "  [#{i + 1             }]    #{version}"
      }
    }
  end

  desc "set VERSION [TARGET=#{System.host}]", 'Choose what version of GCC to use'
  def set (version, target=System.host.to_s)
    versions = self.versions[target]

    if version.numeric? && (version.to_i > versions.length || version.to_i < 1)
      CLI.fatal "#{version} out of index"
      exit 1
    end

    if version.numeric?
      version = versions[version.to_i - 1]
    end

    if !versions.member? version
      CLI.fatal "#{version} version not available for #{target}"
      exit 2
    end

    if target == System.host.to_s
      FileUtils.ln_sf Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/gcc-bin/#{version}/*"), "#{System.env![:INSTALL_PATH]}/usr/bin"
			FileUtils.ln_sf "#{System.env![:INSTALL_PATH]}/usr/lib/gcc/#{System.host}/#{version}/include/g++v4", "#{System.env![:INSTALL_PATH]}/usr/include/g++v4"
    else
      FileUtils.ln_sf Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/#{target}/gcc-bin/#{version}/#{target}-*"), "#{System.env![:INSTALL_PATH]}/usr/bin/"
    end

    CLI.info "Set gcc to #{version} for #{target}"

    Models::Selector.first(:name => 'gcc').update(:data => self.current.merge(target => version))
  end

  no_tasks {
    def current
      (Models::Selector.first(:name => 'gcc').data rescue nil) || {}
    end
  
    def versions
      versions = Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/*").select {|target|
        Host.parse(target.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/", '')) && !target.end_with?('-bin')
      }.map {|target|
        [target.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/", ''), Dir.glob("#{target}/gcc-bin/*").map {|version|
          version.sub("#{target}/gcc-bin/", '')
        }]
      }
  
      versions << [System.host.to_s, Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/gcc-bin/*").map {|version|
        version.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/gcc-bin/", '')
      }]
  
      Hash[versions]
    end
  }
end

Application.start(ARGV)

# gcc: Set the GCC version to use

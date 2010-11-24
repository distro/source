#! /usr/bin/env ruby
require 'optitron'
require 'packo'
require 'packo/binary/helpers'

class Application < Optitron::CLI
  include Packo::Binary::Helpers

  class_opt 'database', 'The path to the cache file', :default => Packo::Environment[:SELECTOR_CACHE]

  desc 'List available gcc versions'
  def list
    info 'List of availaibale gcc versions'

    current = self.current

    self.versions.each_with_index {|version, i|
      puts " [#{version == current ? colorize(i + 1, :GREEN) : i + 1}] \t#{version}"
    }
  end

  desc 'Choose what version of gcc to use'
  def set (version)
    versions = self.versions

    if Packo.numeric?(version) && (version.to_i > versions.length || version.to_i < 1)
      fatal "#{version} out of index"
      exit 1
    end

    if Packo.numeric?(version)
      version = versions[version.to_i - 1]
    end

    if !versions.member? version
      fatal "#{version} version not available"
      exit 2
    end

    FileUtils.ln_sf "/usr/compilers/gcc/#{version}/bin/gcc", '/usr/bin/gcc'
    FileUtils.ln_sf "/usr/compilers/gcc/#{version}/bin/g++", '/usr/bin/g++'

    info "Set gcc to #{version}"

    @db.execute('INSERT OR REPLACE INTO data VALUES(?, ?)', ['gcc', Marshal.dump(version)])
  end

  def current
    Marshal.load(@db.execute('SELECT data FROM data WHERE name = ?', 'gcc').first['data']) rescue nil
  end

  def versions
    Dir.glob('/usr/compilers/gcc/*').map {|version|
      version.sub('/usr/compilers/gcc/', '')
    }
  end
end

Application.dispatch

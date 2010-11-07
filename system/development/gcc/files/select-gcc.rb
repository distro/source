#! /usr/bin/env ruby
require 'optitron'
require 'sqlite3'
require 'packo'
require 'packo_binary/helpers'

class Application < Optitron::CLI
  include PackoBinary::Helpers

  class_opt 'database', 'The path to the cache file', :default => Packo::Environment['SELECT']

  desc 'List available gcc versions'
  def list
    info 'List of availaibale gcc versions'

    current = self.current

    self.versions.each_with_index {|version, i|
      puts " [#{version == current ? colorize(i + 1, :GREEN) : i + 1}] \t#{version}"
    }
  end

  desc 'Choose what version of gcc to use'
  def set (compiler)
    versions = self.versions

    if Packo.numeric?(compiler) && (compiler.to_i > compilers.length || compiler.to_i < 1)
      fatal "#{compiler} out of index"
      exit 1
    end

    if Packo.numeric?(compiler)
      compiler = compilers[compiler.to_i - 1]
    end

    if !compilers.member? compiler
      fatal "#{compiler} compiler not available"
      exit 2
    end

    FileUtils.ln_sf "/usr/compilers/gcc/#{version}/bin/gcc", '/usr/bin/gcc'
    FileUtils.ln_sf "/usr/compilers/gcc/#{version}/bin/g++", '/usr/bin/g++'

    @db.execute('INSERT OR REPLACE INTO data VALUES(?, ?)', ['gcc', Marshal.dump(compiler)])
  end

  def current
    Marshal.load(@db.execute('SELECT data FROM data WHERE name = ?', 'gcc').first['data']) rescue nil
  end

  def versions
    Dir.glob('/usr/compilers/gcc/*').map {|version|
      version.sub('/usr/compilers/gcc/', '')
    }
  end

  def params= (params)
    @params = params

    if File.directory? params['database']
      fatal "#{params['database']} is a directory"
      exit 42
    end

    begin
      FileUtils.mkpath(File.dirname(params['database']))
    rescue Exception => e
      fatal "Could not create #{File.dirname(params['database'])}"
      exit 42
    end

    @db = SQLite3::Database.new(params['database'])
    @db.results_as_hash = true
  end
end

Application.dispatch

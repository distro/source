#! /usr/bin/env ruby
require 'optitron'
require 'sqlite3'
require 'packo'
require 'packo_binary/helpers'

class Application < Optitron::CLI
  include PackoBinary::Helpers

  class_opt 'database', 'The path to the cache file', :default => Packo::Environment['SELECT']

  desc 'List available compilers'
  def list
    info 'List of available compilers'

    current = self.current

    self.compilers.each_with_index {|compiler, i|
      info "  [#{i + 1}]\t#{compiler}  #{colorize('*', :BLUE) if compiler == current}"
    }
  end

  desc 'Choose what compiler to use'
  def set (compiler)
    compilers = self.compilers

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

    name, version = compiler.split('/')

    case name
      when 'gcc'
        FileUtils.ln_s "/usr/compilers/gcc/#{version}/bin/gcc", '/usr/bin/gcc', :force => true
        FileUtils.ln_s "/usr/compilers/gcc/#{version}/bin/g++", '/usr/bin/g++', :force => true

      when 'clang'
    end

    @db.execute('INSERT OR REPLACE INTO data VALUES(?, ?)', ['compiler', Marshal.dump(compiler)])
  end

  desc 'Get path of a file for the given compiler (or current)'
  def path (file, compiler=nil)
    compiler ||= self.current
  end

  def current
    Marshal.load(@db.execute('SELECT data FROM data WHERE name = ?', 'compiler').first['data']) rescue nil
  end

  def compilers
    Dir.glob('/usr/compilers/*').map {|compiler|
      Dir.glob("#{compiler}/*")
    }.flatten.map {|compiler|
      compiler.sub('/usr/compilers/', '')
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

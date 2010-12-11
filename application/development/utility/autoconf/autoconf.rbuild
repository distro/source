Package.define('autoconf') {
  tags 'application', 'system', 'development', 'utility', 'gnu'

  description 'Used to create autoconfiguration files'
  homepage    'http://www.gnu.org/software/autoconf/autoconf.html'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'gnu://autoconf/#{package.version}'

  dependencies << 'development/interpreter/perl!'

  before :configure do |conf|
    ENV['EMACS'] = 'no'
    
    conf.set 'program-suffix', "-#{package.version}"
  end

  before :compile do
    package.environment[:MAKE_JOBS] = 1
  end

  before :pack do
    package.slot = package.version
  end
}

__END__
$$$

$$$ selectors/select-autoconf.rb $$$

#! /usr/bin/env ruby
require 'optitron'

require 'packo'
require 'packo/binary/helpers'

class Application < Optitron::CLI
  include Packo
  include Binary::Helpers
  include Models

  desc 'List available autoconf versions'
  def list
    info 'List of availaibale autoconf versions'

    current = self.current

    self.versions.each_with_index {|version, i|
      puts (current == version) ?
        "  {#{colorize(i + 1, :GREEN)}}    #{version}" :
        "  [#{i + 1}]    #{version}"
    }
  end

  desc 'Choose what version of autoconf to use'
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

    ['autoconf', 'autoheader', 'autom4te', 'autoreconf', 'autoscan', 'autoupdate'].each {|bin|
      FileUtils.ln_sf "#{bin}-#{version}", "/usr/bin/#{bin}"
    }

    info "Set autoconf to #{version}"

    Selector.first(:name => 'autoconf').update(:data => version)
  end

  def current
    (Selector.first(:name => 'autoconf').data rescue nil) || {}
  end

  def versions
    Dir.glob('/usr/bin/autoconf-*').map {|version|
      version.sub('/usr/bin/autoconf-', '')
    }
  end
end

Application.dispatch

# autoconf: Set the default autoconf version

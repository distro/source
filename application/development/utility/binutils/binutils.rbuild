Package.define('binutils') {
  behavior Behaviors::GNU
  use      Modules::Fetching::GNU

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'system', 'development', 'utility'

  description 'Tools necessary to build programs'
  homepage    'http://sources.redhat.com/binutils/'
  license     'GPL-3', 'LGPL-3'

  source 'binutils/#{package.version}'

  features {
    nls {
      before :configure do |conf|
        if enabled?
          conf.without 'included-gettext'
        else
          conf.disable 'nls'
        end
      end
    }
  }

  before :configure do |conf|
    middle = (package.host != package.target) ? "#{package.host}/#{package.target}" : "#{package.target}"

    conf.set 'bindir',     "/usr/#{middle}/binutils-bin/#{package.version}"
    conf.set 'libdir',     "/usr/lib/binutils/#{middle}/#{package.version}"
    conf.set 'libexecdir', "/usr/lib/binutils/#{middle}/#{package.version}"
    conf.set 'includedir', "/usr/lib/binutils/#{middle}/#{package.version}/include"
    conf.set 'datadir',    "/usr/share/binutils-data/#{middle}/#{package.version}"
    conf.set 'infodir',    "/usr/share/binutils-data/#{middle}/#{package.version}/info"
    conf.set 'mandir',     "/usr/share/binutils-data/#{middle}/#{package.version}/man"

    conf.enable  ['secureplt', '65-bit-bfd', 'shared']
    conf.disable ['werror', 'static']

    conf.with 'pkgversion', "Distrø #{package.version}#{" #{package.target}" if package.host != package.target}"

    conf.with 'arch', package.target.arch
  end
}

__END__
$$$

$$$ selectors/select-binutils.rb $$$

#! /usr/bin/env ruby
require 'optitron'

require 'packo'
require 'packo/binary/helpers'

class Application < Optitron::CLI
  include Packo
  include Binary::Helpers
  include Models

  desc 'List available binutils versions'
  def list
    info 'List of availaibale binutils versions'

    current = self.current

    self.versions.each {|target, versions|
      puts ''
      puts colorize(target, :BLUE, :DEFAULT, :BOLD)

      versions.each_with_index {|version, i|
        puts (current[target] == version) ?
          "  {#{colorize(i + 1, :GREEN)}}    #{version}" :
          "  [#{i + 1}]    #{version}"
      }
    }
  end

  desc 'Choose what version of binutils to use'
  def set (version, target=Packo::Host.to_s)
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

    FileUtils.ln_sf Dir.glob("/usr/#{Packo::Host}/#{target}/binutils-bin/#{version}/*"), '/usr/bin/'

    info "Set binutils to #{version} for #{target}"

    Selector.first(:name => 'binutils').update(:data => self.current.merge(target => version))
  end

  def current
    (Selector.first(:name => 'binutils').data rescue nil) || {}
  end

  def versions
    versions = Dir.glob("/usr/#{Packo::Host}/*").select {|target|
      Host.parse(target.sub("/usr/#{Packo::Host}/", '')) && !target.end_with?('-bin')
    }.map {|target|
      [target.sub("/usr/#{Packo::Host}/", ''), Dir.glob("#{target}/binutils-bin/*").map {|version|
        Versionomy.parse(version.sub("#{target}/binutils-bin/", ''))
      }]
    }

    versions << [Packo::Host.to_s, Dir.glob("/usr/#{Packo::Host}/binutils-bin/*").map {|version|
      Versionomy.parse(version.sub("/usr/#{Packo::Host}/binutils-bin/", ''))
    }]

    Hash[versions]
  end
end

Application.dispatch

# binutils: Set the binutils version to use

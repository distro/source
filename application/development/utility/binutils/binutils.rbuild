Package.define('binutils') {
  tags 'application', 'system', 'development', 'utility', 'gnu'

  description 'Tools necessary to build programs'
  homepage    'http://sources.redhat.com/binutils/'
  license     'GPL-3', 'LGPL-3'

  maintainer 'meh. <meh@paranoici.org>'

  source 'gnu://binutils/#{package.version}'

	flavor {
		headers {
			avoid :before, :pack, :headers
		}

		documentation {
			before :pack do
				if disabled?
					FileUtils.rm_rf "#{distdir}/usr/share", :secure => true
				end
			end
		}
	}

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
      next if versions.empty?

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
      FileUtils.ln_sf Dir.glob("/usr/#{System.host}/binutils-bin/#{version}/*"), '/usr/bin'
    else
      FileUtils.ln_sf Dir.glob("/usr/#{System.host}/#{target}/binutils-bin/#{version}/#{target}-*"), '/usr/bin/'
    end

    info "Set binutils to #{version} for #{target}"

    Selector.first(:name => 'binutils').update(:data => self.current.merge(target => version))
  end

  def current
    (Selector.first(:name => 'binutils').data rescue nil) || {}
  end

  def versions
    versions = Dir.glob("/usr/#{System.host}/*").select {|target|
      Host.parse(target.sub("/usr/#{System.host}/", '')) && !target.end_with?('-bin')
    }.map {|target|
      [target.sub("/usr/#{System.host}/", ''), Dir.glob("#{target}/binutils-bin/*").map {|version|
        Versionomy.parse(version.sub("#{target}/binutils-bin/", ''))
      }]
    }

    versions << [System.host.to_s, Dir.glob("/usr/#{System.host}/binutils-bin/*").map {|version|
      Versionomy.parse(version.sub("/usr/#{System.host}/binutils-bin/", ''))
    }]

    Hash[versions]
  end
end

Application.dispatch

# binutils: Set the binutils version to use

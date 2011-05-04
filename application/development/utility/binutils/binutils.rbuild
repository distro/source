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
        if disabled? && !flavor.vanilla?
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
    if host != target
      conf.with 'sysroot', "/usr/#{host}/#{target}"

      middle = "#{package.host}/#{package.target}"
    else
      middle = target.to_s
    end

    conf.set 'bindir',     "/usr/#{middle}/binutils-bin/#{package.version}"
    conf.set 'libdir',     "/usr/lib/binutils/#{middle}/#{package.version}"
    conf.set 'libexecdir', "/usr/lib/binutils/#{middle}/#{package.version}"
    conf.set 'includedir', "/usr/lib/binutils/#{middle}/#{package.version}/include"
    conf.set 'datadir',    "/usr/share/binutils-data/#{middle}/#{package.version}"
    conf.set 'infodir',    "/usr/share/binutils-data/#{middle}/#{package.version}/info"
    conf.set 'mandir',     "/usr/share/binutils-data/#{middle}/#{package.version}/man"

		conf.with 'binutils-ldscript-dir', "/usr/lib/binutils/#{middle}/#{package.version}/ldscripts"

    conf.enable  ['secureplt', '64-bit-bfd', 'shared']
    conf.disable ['werror', 'static']

    conf.with 'pkgversion', "Distrø #{package.version}#{" #{package.target}" if package.host != package.target}"

    conf.with 'arch', package.target.arch
  end

	before :pack do
    if host != target
      middle = "#{package.host}/#{package.target}"
    else
      middle = target.to_s
    end

		Do.rm Dir["#{distdir}/usr/#{middle}/bin/*"]
		Do.mv "#{distdir}/usr/#{middle}/lib/ldscripts", "#{distdir}/usr/#{middle}/#{version}"
	end
}

__END__
$$$

$$$ selectors/select-binutils.rb $$$

#! /usr/bin/env ruby
require 'packo'
require 'packo/cli'
require 'packo/models'

class Application < Thor
  include Packo

  desc 'list', 'List available binutils versions'
  def list
    CLI.info 'List of availaibale binutils versions'

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

  desc "set VERSION [TARGET=#{System.host}]", 'Choose what version of binutils to use'
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

    files = ['ar', 'as', 'ld', 'nm', 'objcopy', 'objdump', 'ranlib', 'strip']

    if target == System.host.to_s
      files.each {|file|
        FileUtils.ln_sf "#{System.env![:INSTALL_PATH]}/usr/#{System.host}/binutils-bin/#{version}/#{file}", "#{System.env![:INSTALL_PATH]}/usr/bin/#{target}-#{file}"
        FileUtils.ln_sf "#{System.env![:INSTALL_PATH]}/usr/#{System.host}/binutils-bin/#{version}/#{file}", "#{System.env![:INSTALL_PATH]}/usr/bin/#{file}"
      }
    else
      files.each {|file|
        FileUtils.ln_sf "#{System.env![:INSTALL_PATH]}/usr/#{System.host}/#{target}/binutils-bin/#{version}/#{file}", "#{System.env![:INSTALL_PATH]}/usr/bin/#{target}-#{file}"
      }
    end

    CLI.info "Set binutils to #{version} for #{target}"

    Models::Selector.first(:name => 'binutils').update(:data => self.current.merge(target => version))
  end

  no_tasks {
    def current
      (Models::Selector.first(:name => 'binutils').data rescue nil) || {}
    end

    def versions
      versions = Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/*").select {|target|
        Host.parse(target.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/", '')) && !target.end_with?('-bin')
      }.map {|target|
        [target.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/", ''), Dir.glob("#{target}/binutils-bin/*").map {|version|
          Versionomy.parse(version.sub("#{target}/binutils-bin/", ''))
        }]
      }

      versions << [System.host.to_s, Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/binutils-bin/*").map {|version|
        Versionomy.parse(version.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/binutils-bin/", ''))
      }]

      Hash[versions]
    end
  }
end

Application.start(ARGV)

# binutils: Set the binutils version to use

Package.define('binutils') {
  tags 'application', 'system', 'development', 'utility', 'gnu'

  description 'Tools necessary to build programs'
  homepage    'http://sources.redhat.com/binutils/'
  license     'GPL-3', 'LGPL-3'

  maintainer 'meh. <meh@paranoici.org>'

  source 'gnu://binutils/#{version}'

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
	end
}

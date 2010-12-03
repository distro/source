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
    conf.set 'bindir',     "/usr/#{package.target}/binutils-bin/#{package.version}"
    conf.set 'libdir',     "/usr/lib/binutils/#{package.target}/#{package.version}"
    conf.set 'libexecdir', "/usr/lib/binutils/#{package.target}/#{package.version}"
    conf.set 'includedir', "/usr/lib/binutils/#{package.target}/#{package.version}/include"
    conf.set 'datadir',    "/usr/share/binutils-data/#{package.target}/#{package.version}"
    conf.set 'infodir',    "/usr/share/binutils-data/#{package.target}/#{package.version}/info"
    conf.set 'mandir',     "/usr/share/binutils-data/#{package.target}/#{package.version}/man"

    if Environment[:CROSS]
      conf.set 'bindir', "/usr/#{package.host}/#{package.target}/binutils-bin/#{package.version}"    
    end

    conf.enable  ['secureplt', '64-bit-bfd', 'shared']
    conf.disable ['werror', 'static']

    conf.with 'pkgversion', "Distrø #{package.version}#{" #{package.target}" if package.host != package.target}"

    conf.with 'arch', package.target.arch
  end

  before :pack do
    package.slot = package.target.to_s if package.host != package.target
  end

  after :unpack do

  end
}

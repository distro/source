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
    conf.enable  ['plugins', 'shared-libgcc', '64-bit-bfd', 'version-specific-runtime-libs']
    conf.disable ['werror', 'bootstrap', '__cxa_atexit', 'sjlj-exceptions', 'symvers']
    conf.with    ['gnu-ld', 'gnu-as', 'dwarf2']

    conf.enable 'threads', 'posix'
    conf.with   'pkgversion', "Distrø #{package.version}"
    conf.with   'arch', Modules::Building::Autotools::Host.new(package.environment).arch

    case package.environment[:LIBC]
      when 'newlib'; conf.with 'newlib'
    end
  end

  before :pack do
    package.slot = "#{environment[:ARCH]}-#{environment[:KERNEL]}"
  end
}

Package.define('v8') {
  use Fetching::Subversion, Building::Scons

  tags 'application', 'interpreter', 'development', 'javascript', 'embeddable', 'google'

  description "Google's open source JavaScript engine"
  homepage    'http://code.google.com/p/v8'
  license     'BSD'

  maintainer 'meh. <meh@paranoici.org>'

  subversion Hash[
    repository: 'http://v8.googlecode.com/svn',
    tag:        '#{package.version}'
  ]

  flavor {
    debug {
      before :configure do |conf|
        conf.set 'mode', enabled? ? 'debug' : 'release'
      end
    }
  }

  features {
    self.set('readline') {
      before :configure do |conf|
        conf.set 'console', 'readline' if enabled?
      end
    }
  }

  before :patch do
    Do.sed 'SConstruct', ["'-Werror',", '']
  end

  before :configure do |conf|
    env[:LINKFLAGS] = env[:LDFLAGS]

    case package.target
      when 'i?86-*'   then conf.set 'arch', 'ia32'
      when 'x86_64-*' then conf.set 'arch', 'x64'
      when 'arm*-*'   then conf.set 'arch', 'arm'

      else raise ArgumentError.new 'v8 is not compatible with this arch'
    end

    conf.enable 'soname'

    conf.set 'library',    'shared'
    conf.set 'sample',     'shell'
    conf.set 'visibility', 'default'
    conf.set 'importenv',  'LINKFLAGS,WARNINGFLAGS,PATH,'
  end

  after :install do
    package.do.into '/usr/include' do
      package.do.ins 'include/*.h'
    end

    package.do.lib "libv8-#{package.version}.so"
    package.do.sym "libv8-#{package.version}.so", '/usr/lib/libv8.so'

    package.do.into '/usr' do
      package.do.bin ['shell', 'google-shell']
    end
  end
}

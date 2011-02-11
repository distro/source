Package.define('rubinius') {
  avoid Modules::Building::Autotools
  use   Modules::Building::Rake

  tags 'application', 'interpreter', 'development', 'ruby'

  description 'An environment for the Ruby programming language providing performance, accessibility, and improved programmer productivity'
  homepage    'http://rubini.us/'
  license     'BSD'

  maintainer 'meh. <meh@paranoici.org>'

  source 'github://evanphx/rubinius/release-#{package.version}'

  dependencies << '>=library/system/development/llvm-2.8'

  after :unpack do
    Do.cd Dir.glob("#{workdir}/*").first
  end

  before :compile do
    environment[:LD] = environment[:CXX]

    conf = Modules::Building::Autotools::Configure.new

    conf.set 'prefix',     "#{distdir}/usr"
    conf.set 'gemsdir',    "#{distdir}/usr/lib/ruby"
    conf.set 'includedir', "#{distdir}/usr/include/rubinius"
    conf.set 'mandir',     "#{distdir}/usr/share"
    conf.set 'libdir',     "#{distdir}/usr/lib/rubinius"
    conf.set 'sitedir',    "#{distdir}/usr/lib/rubinius/site"
    conf.set 'vendordir',  "#{distdir}/usr/lib/rubinius/vendor"

    Packo.sh "./configure #{conf}"

    package.rake.do 'build'

    throw :halt
  end

  after :install do
    [:rake, :rdoc, :ruby, :ri, :gem, :irb].each {|file|
      Do.rm("#{distdir}/usr/bin/#{file}")
    }
  end
}

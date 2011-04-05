Package.define('spidermonkey') {
  tags 'application', 'interpreter', 'development', 'javascript', 'embeddable'

  description 'Mozilla JavaScript engine.'
  homepage    'http://www.mozilla.org/js/spidermonkey/'
  license     'MPL'

  maintainer 'meh. <meh@paranoici.org>'

  after :unpack do
    Do.cd "js-#{package.version}/js/src"
  end

  before :pack do
    package.do.into '/usr/lib' do
      package.do.sym 'libmozjs185.so.1.0.0', 'libmozjs185.so.1.0'
      package.do.sym 'libmozjs185.so.1.0', 'libmozjs185.so'
    end

    Do.cp 'shell/js', "#{distdir}/usr/bin/mozilla-js"
  end
}

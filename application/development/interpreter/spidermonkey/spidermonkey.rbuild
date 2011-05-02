Package.define('spidermonkey') {
  tags 'application', 'interpreter', 'development', 'javascript', 'embeddable', 'mozilla'

  description 'Mozilla JavaScript engine.'
  homepage    'http://www.mozilla.org/js/spidermonkey/'
  license     'MPL'

  maintainer 'meh. <meh@paranoici.org>'

  features {
    ctypes {
      before :configure do |conf|
        conf.enable 'ctypes', enabled?
      end
    }
  }

  after :unpack do
    Do.cd "js-#{package.version}/js/src"
  end

  before :configure do |conf|
    conf.enable 'threadsafe'
    conf.with   'system-nspr'
  end

  before :pack do
    package.do.into '/usr' do
      package.do.bin 'shell/js', 'mozilla-js'
    end
  end
}

Package.define('spidermonkey') {
  tags 'application', 'interpreter', 'development', 'javascript', 'embeddable'

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
    Do.cp 'shell/js', "#{distdir}/usr/bin/mozilla-js"

    File.chmod 0755, "#{distdir}/usr/bin/mozilla-js"
  end
}

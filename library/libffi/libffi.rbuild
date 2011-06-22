Package.define('libffi') { type 'library'
  tags 'library'

  description 'A portable, high level programming interface to various calling conventions.'
  homepage    'http://sourceware.org/libffi/'
  license     'MIT'

  maintainer  'shura <shura1991@gmail.com>'

  source      'ftp://sourceware.org/pub/libffi/libffi-#{version.gsub(\'_\', \'\')}.tar.gz'

  flavor {
    static {
      before :configure do |conf|
        conf.enable 'static' if enabled?
      end
    }

    debug {
      before :configure do |conf|
        conf.enable 'debug' if enabled?
      end
    }
  }

  before :configure do |conf|
    begin
      env[:HOST] = env[:CHOST] if System.has?('coreutils').tags.include?('bsd')
    rescue
    end

    conf.enable 'dependency-tracking'
  end

  after :unpack do
    Do.cd "#{package.workdir}/libffi-#{package.version.to_s.gsub('_', '')}"
  end
}

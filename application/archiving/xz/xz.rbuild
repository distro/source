Package.define('xz') {
  tags 'application', 'archiving'

  description 'Library and command line tools for XZ and LZMA compressed files'
  homepage    'http://tukaani.org/xz/'
  license     'LGPL-2.1'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://tukaani.org/xz/xz-#{version}.tar.gz'

  flavor {
    static {
      before :configure do |conf|
        conf.enable 'static', enabled?
      end
    }
  }

  features {
    threads {
      before :configure do |conf|
        conf.enable 'threads', enabled?
      end
    }

    nls {
      before :configure do |conf|
        conf.enable 'nls', enabled?
      end
    }
  }
}

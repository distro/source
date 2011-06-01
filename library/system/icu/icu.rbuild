Package.define('icu') {
  tags 'library', 'text', 'unicode'

  description 'International Components for Unicode'
  homepage    'http://site.icu-project.org/'
  license     'BSD'

  maintainer 'Bronsa <brobronsa@gmail.com>'

  source default: 'http://download.icu-project.org/files/icu4c/#{version}/icu4c-#{version.gsub(".", "_")}-src.tgz'

  flavor {
    documentation {
      if !(disabled? && !flavor.vanilla?)
        before :dependencies do |deps|
          deps << 'archiving/unzip!'
        end

        before :fetch do
          package.source[:docs] = 'http://download.icu-project.org/files/icu4c/#{version}/icu4c-#{version.gsub(".", "_")}-docs.tgz'
        end

        after :install do
          package.do.html package.unpack(package.distfiles[:docs])
          package.do.html 'readme.html'
        end
      end
    }
  }

  features {
    debug {
      before :configure do |conf|
        conf.with 'debug', enabled?
      end
    }
    static {
      before :configure do |conf|
        conf.with 'static', enabled?
      end
    }
  }

  after :unpack do
    Do.cd "#{workdir}/icu/source"
  end

  after :patch do
    Do.sed('config/Makefile.inc.in', [/(C|CPP|CXX|F|LD)FLAGS =(.*)/, '\1FLAGS = @\1FLAGS@ \2'])
  end
}

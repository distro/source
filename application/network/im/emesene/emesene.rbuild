Package.define('emesene') {
  behavior Behaviors::Python

  tags 'application', 'network', 'im'

  description 'Platform independent MSN Messenger client written in Python+GTK'
  homepage    'http://emesene.org/'
  license     'GPL-2'

  maintainer 'KinG-InFeT <king-infet@autistici.org>'

  source 'sourceforge://emesene/emesene-#{package.version}/emesene-#{package.version}'

  dependencies << 'application/interpreter/python' << 'library/python/pygtk' << 'library/python/gst-python' << 'library/media/gst-plugins-meta'

  features {
    webcam {
      before :patch do
        Do.sed 'setup.py', [/(\[.*?)libmimic_module(.*?\])/, '\1\2']
      end
    }
  }

  before :install do
    package.do.into '/usr/share/emesene' do
      package.do.ins 'build/lib/*'

      package.do.chmod 0755 do
        package.do.ins 'build/scripts*/emesene'
      end
    end

    package.do.sym '/usr/share/emesene/emesene', '/usr/bin/emesene'
  end
}

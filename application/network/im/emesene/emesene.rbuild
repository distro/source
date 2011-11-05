maintainer 'KinG-InFeT <king-infet@autistici.org>'

behavior Python

name 'emesene'
tags 'application', 'network', 'im'

description 'Platform independent MSN Messenger client written in Python+GTK'
homepage    'http://emesene.org/'
license     'GPL-2'

source 'github://emesene/emesene/v#{package.version}'

dependencies << 'application/interpreter/python' << 'library/python/pygtk' << 'library/python/gst-python' << 'library/media/gst-plugins-meta'

features {
	webcam {
		description 'Enable webcam support'

		before :patch do
			Do.sed 'setup.py', [/(\[.*?)libmimic_module(.*?\])/, '\1\2']
		end
	}
}

package.setup.version 2

after :unpack do
	Do.cd 'emesene*'
end

before :install do
	package.do.into '/usr/share/emesene' do
		package.do.ins 'build/lib/emesene/*'

		package.do.chmod %w(rwx rx rx) do
			package.do.ins 'build/scripts*/emesene'
		end
	end

	package.do.into '/usr/share/icons' do
		package.do.ins 'emesene/data/icons/*'
	end

	package.do.sym '../share/emesene/emesene', 'usr/bin/emesene'
end

maintainer 'meh. <meh@paranoici.org>'

name 'sylpheed'
tags 'application', 'mail', 'client'

description 'A lightweight email client and newsreader'
homepage    'http://sylpheed.sraoss.jp/'
license     'GPL-2', 'LGPL-2.1'

source 'http://sylpheed.sraoss.jp/sylpheed/v#{version.major}.#{version.minor}/sylpheed-#{version}.tar.bz2'

dependencies << 'misc/mime-types' << 'misc/network/curl' << 'misc/x11/shared-mime-info'

features {
	ipv6 {
		before :configure do |conf|
			conf.enable 'ipv6', enabled?
		end
	}

	ssl {
		before :configure do |conf|
			conf.enable 'ssl', enabled?
		end
	}

	crypt {
		before :dependecies do |deps|
			deps << 'application/crypt/gpgme'
		end

		before :configure do |conf|
			conf.enable 'gpgme', enabled?

			if disabled?
				Do.cp 'ac/missing/gpgme.m4', 'ac/'
			end
		end
	}

	ldap {
		before :configure do |conf|
			conf.enable 'ldap', enabled?
		end
	}

	nls { }

	pda {
		before :dependencies do |deps|
			deps << 'application/pda/jpilot'
		end

		before :configure do |conf|
			conf.enable 'jpilot', enabled?
		end
	}

	spell {
		before :dependencies do |deps|
			deps << 'application/text/gtkspell'
		end

		before :configure do |conf|
			conf.enable 'gtkspell', enabled?
		end
	}

	xface {
		before :dependencies do |deps|
			deps << 'library/media/compface!'
		end

		before :configure do |conf|
			conf.enable 'compface', enabled?
		end
	}
}

before :configure do |conf|
	autotools.m4 = 'ac'
	autotools.aclocal

	htmldir = Path.clean("/usr/share/doc/sylpheed-#{package.version}")

	conf.with 'manualdir', "#{htmldir}/manual"
	conf.with 'faqdir',    "#{htmldir}/faq"

	conf.disable 'updatecheck'
end

after :install do |conf|
	package.do.doc 'AUTHORS', 'ChangeLog*', 'NEWS*', 'README*', 'TODO*'
end

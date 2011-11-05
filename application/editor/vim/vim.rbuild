maintainer 'meh. <meh@paranoici.org>'

name 'vim'
tags 'application', 'editor'

description 'Vim, an improved vi-style text editor'
homepage    'http://www.vim.org/'
license     'vim'

source 'ftp://ftp.vim.org/pub/vim/unix/vim-#{version.major}.#{version.minor}.tar.bz2'

features {
	ruby {
		before :configure do |conf|
			conf.enable 'rubyinterp', enabled?
		end
	}

	perl {
		before :configure do |conf|
			conf.enable 'perlinterp', enabled?
		end
	}

	mzscheme {
		before :configure do |conf|
			conf.enable 'mzschemeinterp', enabled?
		end
	}

	lua {
		before :configure do |conf|
			conf.enable 'luainterp', enabled?
		end
	}

	tcl {
		before :configure do |conf|
			conf.enable 'tclinterp', enabled?
		end
	}

	python {
		before :dependencies do |deps|
			deps << 'development/interpreter/python%2'
		end

		before :configure do |conf|
			conf.enable 'pythoninterp', enabled?
		end
	}

	python3 {
		before :dependencies do |deps|
			deps << 'development/interpreter/python%3'
		end

		before :configure do |conf|
			conf.enable 'python3interp', enabled?
		end
	}

	X {
		before :configure do |conf|
			conf.with 'x', enabled?
		end
	}

	gtk {
		needs 'X'

		before :configure do |conf|
			if enabled?
				conf.enable 'gtk2-check'
				conf.enable 'gui', 'gtk2'
			end
		end
	}

	gnome {
		needs 'X'

		before :configure do |conf|
			if enabled?
				conf.enable 'gtk2-check'
				conf.enable 'gui', 'gnome2'
			end
		end
	}

	netbeans {
		before :configure do |conf|
			conf.enable 'netbeans', enabled?
		end
	}

	cscope {
		before :dependencies do |deps|
			deps << 'development/utility/cscope'
		end
	}

	gpm {

	}
}

after :initialize do
	next unless package.version.tiny.to_i > 0

	package.source = [package.source].flatten

	1.upto(package.version.tiny.to_i) {|p|
		package.source << "ftp://ftp.vim.org/pub/vim/patches/#{version.major}.#{version.minor}/#{version.major}.#{version.minor}.#{'%03d' % p}"
	}
end

after :unpack do
	Do.cd "#{package.workdir}/vim#{package.version.major}#{package.version.minor}"
end

before :patch do
	next unless package.version.tiny.to_i > 0

	CLI.info "Applying #{package.version.tiny} patches, be patient"

	package.distfiles[1, package.distfiles.length].each {|p|
		package.patch(p.path, silent: true) rescue nil
	}
end

after :dependencies do |result, deps|
	deps.delete_if {|dep|
		dep.name == 'python' && !dep.slot
	}
end

# this fixes the configure, or it would be called during compile time
before :configure do
	# Patch to build with ruby-1.8.0_pre5 and following
	Do.sed 'src/if_ruby.c', ['defout', 'stdout']
	Do.sed 'src/configure.in', [' libc.h ', ' ']

	# Read vimrc and gvimrc from /etc/vim
	File.append 'src/feature.h', %{#define SYS_VIMRC_FILE  "#{env[:INSTALL_PATH]}/etc/vim/vimrc"}
	File.append 'src/feature.h', %{#define SYS_GVIMRC_FILE "#{env[:INSTALL_PATH]}/etc/vim/gvimrc"}

	env[:CFLAGS].delete('-funroll-all-loops')
	env[:CFLAGS].replace('-O3', '-O2')

	autotools.make '-j1', '-C', 'src', 'autoconf'
end

before :configure do |conf|
	conf.with 'modified-by', 'Distrø'

	conf.with 'features', 'huge'
	conf.with 'tlib', 'curses'

	if !(features.gtk.enabled? || features.gnome.enabled?)
		conf.enable 'gui', 'no'
	end
end

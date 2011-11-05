maintaner 'meh. <meh@paranoici.org>'

name 'ctags'
tags 'application', 'development', 'utility'

description 'Exuberant ctags generates tags files for quick source navigation.'
homepage    'http://ctags.sourceforge.net'
license     'GPL-2'

source 'sourceforge://ctags/ctags/#{version}/ctags-#{version}'

before :configure do |conf|
	conf.enable 'tmpdir', '/tmp'

	conf.disable ['etags']
	conf.with    ['posix-regex']
	conf.without ['readlib']
end

after :install do |conf|
	package.do.doc 'FAQ', 'NEWS', 'README'
	package.do.html 'EXTENDING.html', 'ctags.html'
end

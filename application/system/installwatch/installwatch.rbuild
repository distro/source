maintainer 'meh. <meh@paranoici.org>'

name 'installwatch'
tags 'application', 'system'

description 'Installwatch is an extremely simple utility to keep track of created and modified files during the installation of a new program.'
homepage    'http://asic-linux.com.mx/~izto/checkinstall/installwatch.html'
license     'GPL-2'

before :configure do |conf|
	env[:PREFIX] = Path.clean(env[:INSTALL_PATH] + '/usr')

	skip
end

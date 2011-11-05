maintainer 'meh. <meh@paranoici.org>'

behavior Custom
use      Helpers::Python, Fetching::Git

name'netcommander'
tags 'application', 'network', 'hacking'

description 'justniffer is a tcp packet sniffer that can log network traffic in a customizable way'
homepage    'http://justniffer.sourceforge.net/'
license     'GPL-3'

source Location.new(
	type:       'git',
	repository: 'git://github.com/evilsocket/NetCommander.git',
)

py.version 2

before :install do |conf|
	py.fix_shebang 'netcmd.py', 2

	package.do.into '/usr' do
		package.do.sbin ['netcmd.py', 'netcmd']
	end
end

arch     '~x86', '~amd64'
kernel   'linux'
compiler 'gcc'
libc     'glibc'

use Fetching::Bazaar

source Location[
	repository: 'http://code.bitlbee.org/',
	branch:     'bitlbee'
]

flavor {
	killer {
		description 'Experimental bitlbee branch'

		before :fetch do
			source[:branch] = 'killerbee'
		end
	}
}

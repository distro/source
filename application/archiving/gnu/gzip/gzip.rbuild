Package.define('gzip') {
  tags 'application', 'archiving', 'gnu'

  description 'Standard GNU compressor'
  homepage    'http://www.gnu.org/software/gzip/'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'gnu://gzip/#{version}'
}

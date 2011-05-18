Package.define('asciiportal') {
  tags 'application', 'game', 'text', 'action', 'puzzle'

  description 'ASCIIpOrtal is a Portal™ text-based remake'
  homepage    'http://cymonsgames.com/asciiportal/'
  license     'MIT'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://cymonsgames.com/games/asciiportal/asciiportal#{package.version}-src.zip'

  dependencies << 'library/pdcurses'

  features {
    sdl { enabled!; force!
      before :configure do
        if enabled?
          package.environment[:LDFLAGS] << '-lSDL'
        else
          package.environment[:CXXFLAGS] << '-D__NOSDL__'
        end
      end
    }

    sound {
      needs 'sdl'

      before :configure do
        if enabled?
          package.environment[:LDFLAGS] << '-lSDL_mixer'
        else
          package.environment[:CXXFLAGS] << '-D__NOSOUND__'
        end
      end
    }
  }

  after :initialize do
    package.arguments = []

		autotools.disable!
  end

  after :unpack do
    Do.cd workdir
  end

  before :compile do
    files = ['ap_input', 'ap_draw', 'ap_play', 'ap_sound', 'main', 'menu']
    
    files.each {|file|
      Packo.sh "#{environment[:CXX]} #{environment[:CXXFLAGS]} -c #{file}.cpp -o #{file}.o"
    }

    Packo.sh "#{environment[:CXX]} #{environment[:LDFLAGS]} -o asciiportal #{files.join(' ')}"

    skip
  end
}

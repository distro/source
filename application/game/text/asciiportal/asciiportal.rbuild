Package.define('asciiportal') {
  behavior Behaviors::Standard

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'game', 'text', 'action', 'puzzle'

  description 'ASCIIpOrtal is a Portal™ text-based remake'
  homepage    'http://cymonsgames.com/asciiportal/'
  license     'MIT'

  source 'http://cymonsgames.com/games/asciiportal/asciiportal#{package.version}-src.zip'

  dependencies << 'library/text/ncurses'

  features {
    sdl {
      before :configure do
        if enabled?
          package.environment[:LDFLAGS] << ' -lSDL'
        else
          package.environment[:CXXFLAGS] << ' -D__NOSDL__'
        end
      end
    }

    sound {
      before :configure do
        if package.features.sdl.disabled?
          Packo.warn 'sdl is disabled, ignoring sound'
        end

        if enabled? && package.features.sdl.enabled?
          package.environment[:LDFLAGS] << ' -lSDL_mixer'
        else
          package.environment[:CXXFLAGS] << ' -D__NOSOUND__'
        end
      end
    }
  }

  after :initialize do
    package.arguments = []
  end

  after :unpack do
    Do.cd workdir
  end

  before :compile do
    files = ['ap_input', 'ap_draw', 'ap_play', 'ap_sound', 'main', 'menu']
    
    files.each {|file|
      Packo.sh "#{environment[:CXX]} #{environment[:CXXFLAGS]} -c #{file}.c -o #{file}.o"
    }

    Packo.sh "#{environment[:CXX]} #{environment[:LDFLAGS]} -o asciiportal #{files.join(' ')}"

    throw :halt
  end
}

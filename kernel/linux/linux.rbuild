Package.define('linux') { type 'kernel'
  avoid Modules::Building::Autotools

  tags 'kernel'

  description 'An operating system kernel used by the Linux family of Unix-like operating systems.'
  homepage    'http://kernel.org'
  license     'GPL-2'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://kernel.org/pub/linux/kernel/v#{package.version.major}.#{package.version.minor}/linux-#{package.version}.tar.bz2'

  def zen! (patch);   package.zen = patch end
  def zen?;         !!package.zen         end

  def grsecurity! (patch);   package.grsecurity = patch end
  def grsecurity?;         !!package.grsecurity         end

  after :initialize do
    package.source = [package.source].flatten

    features {
      if package.zen?
        package.source << package.zen

        zen {
          description 'The Zen Kernel is a the result of a collaborative effort of kernel hackers to provide the best Linux kernel possible for every day systems.'
        }
      end

      if package.grsecurity?
        package.source << package.grsecurity

        grsecurity {
          description 'grsecurity is an innovative approach to security utilizing a multi-layered detection, prevention, and containment model.'

          after :unpack do
            
          end
        }
      end
    }
  end

  after :unpack do
    Do.mv "#{workdir}/linux-#{version}", "#{distdir}/usr/src/linux#{'-zen' if features.zen.enabled?}#{'-gr' if features.grsecurity.enabled?}-#{version}"

    throw :halt
  end
}

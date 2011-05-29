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
    package.source = { :default => package.source }

    features {
      if package.zen?
        package.source[:zen] = package.zen

        zen {
          description 'The Zen Kernel is a the result of a collaborative effort of kernel hackers to provide the best Linux kernel possible for every day systems.'

          after :unpack, :priority => -1 do
            package.patch package.unpack(package.distfiles[:zen]), :level => 1 if enabled?
          end
        }
      end

      if package.grsecurity?
        package.source[:grsecurity] = package.grsecurity

        grsecurity {
          description 'grsecurity is an innovative approach to security utilizing a multi-layered detection, prevention, and containment model.'

          after :unpack, :priority => -1 do
            package.patch package.distfiles[:grsecurity], :level => 1 if enabled?
          end
        }
      end
    }
  end

  after :unpack do
    Do.mv "#{workdir}/linux-#{version}", "#{distdir}/usr/src/linux#{'-zen' if features.zen?}#{'-gr' if features.grsecurity?}-#{version}"

    skip
  end

  before :pack do
    package.slot = "#{package.version}#{'-zen' if features.zen?}#{'-gr' if features.grsecurity?}"
  end
}

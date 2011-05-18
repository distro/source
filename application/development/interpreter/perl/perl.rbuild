Package.define('perl') {
  tags 'application', 'development', 'interpreter'

  description 'Larry Wall\'s Practical Extraction and Report Language'
  homepage    'http://www.perl.org/'
  license     'Artistic', 'GPL-1', 'GPL-2', 'GPL-3'

  source 'http://www.cpan.org/src/#{package.version.major}.0/perl-#{package.version}.tar.bz2'

  features {
    threads {
      before :configure do
        package.flags << '-Dusethreads' if enabled?
      end
    }

    berkdb {

    }

    gdbm {

    }
  }

  before :initialize do
    package.flags = Flags.new
  end

  before :configure do
    environment[:CFLAGS].delete('-malign-double', '-fsched2-use-superblocks').push('-O2')

    flags.push(
      '-des', '-Duseshrplib', '-Duselargefiles', '-Dd_semctl_semun', '-Ud_csh', '-Uusenm',
      '-Dcf_by=Distrø', "-Dlibperl=libperl.so.#{package.version}",
      "-Darchname=#{System.host}#{'-thread' if features.threads?}",
      "-Dcc=#{environment[:CC]}", "-Doptimize=#{environment[:CFLAGS]}", "-Dldflags=#{environment[:LDFLAGS]}",
      "-Dprefix=#{(env[:INSTALL_PATH] + 'usr').cleanpath}", "-Dsiteprefix=#{(env[:INSTALL_PATH] + 'usr').cleanpath}",
      "-Dvendorprefix=#{(env[:INSTALL_PATH] + 'usr').cleanpath}", "-Dscriptdir=#{(env[:INSTALL_PATH] + 'usr/bin').cleanpath}",
      "-Dprivlib=#{(env[:INSTALL_PATH] + "usr/lib/perl#{package.version.major}/#{package.version}").cleanpath}",
      "-Darchlib=#{(env[:INSTALL_PATH] + "usr/lib/perl#{package.version.major}/#{package.version}/#{System.host}#{'-thread' if features.threads?}").cleanpath}",
      "-Dsitelib=#{(env[:INSTALL_PATH] + "usr/lib/perl#{package.version.major}/site_perl/#{package.version}").cleanpath}",
      "-Dsitearch=#{(env[:INSTALL_PATH] + "usr/lib/perl#{package.version.major}/site_perl/#{package.version}/#{System.host}#{'-thread' if features.threads?}").cleanpath}",
      "-Dvendorlib=#{(env[:INSTALL_PATH] + "usr/lib/perl#{package.version.major}/vendor_perl/#{package.version}").cleanpath}",
      "-Dvendorarch=#{(env[:INSTALL_PATH] + "usr/lib/perl#{package.version.major}/vendor_perl/#{package.version}/#{System.host}#{'-thread' if features.threads?}").cleanpath}",
      "-Dman1dir=#{(env[:INSTALL_PATH] + 'usr/share/man/man1').cleanpath}", "-Dman3dir=#{(env[:INSTALL_PATH] + 'usr/share/man/man3').cleanpath}",
      "-Dsiteman1dir=#{(env[:INSTALL_PATH] + 'usr/share/man/man1').cleanpath}", "-Dsiteman3dir=#{(env[:INSTALL_PATH] + 'usr/share/man/man3').cleanpath}",
      "-Dvendorman1dir=#{(env[:INSTALL_PATH] + 'usr/share/man/man1').cleanpath}", "-Dvendorman3dir=#{(env[:INSTALL_PATH] + 'usr/share/man/man3').cleanpath}",
      '-Dman1ext=1', '-Dman3ext=3pm', '-Dmyhostname=localhost', '-Dperladmin=root@localhost', '-Dinstallusrbinperl=n'
    )

    Packo.sh './Configure', *flags

    skip
  end
}

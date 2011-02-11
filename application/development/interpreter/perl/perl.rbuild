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
      "-Dprefix=#{System.env[:INSTALL_PATH]}/usr", "-Dsiteprefix=#{System.env[:INSTALL_PATH]}/usr",
      "-Dvendorprefix=#{System.env[:INSTALL_PATH]}/usr", "-Dscriptdir=#{System.env[:INSTALL_PATH]}/usr/bin",
      "-Dprivlib=#{System.env[:INSTALL_PATH]}/usr/lib/perl#{package.version.major}/#{package.version}",
      "-Darchlib=#{System.env[:INSTALL_PATH]}/usr/lib/perl#{package.version.major}/#{package.version}/#{System.host}#{'-thread' if features.threads?}",
      "-Dsitelib=#{System.env[:INSTALL_PATH]}/usr/lib/perl#{package.version.major}/site_perl/#{package.version}",
      "-Dsitearch=#{System.env[:INSTALL_PATH]}/usr/lib/perl#{package.version.major}/site_perl/#{package.version}/#{System.host}#{'-thread' if features.threads?}",
      "-Dvendorlib=#{System.env[:INSTALL_PATH]}/usr/lib/perl#{package.version.major}/vendor_perl/#{package.version}",
      "-Dvendorarch=#{System.env[:INSTALL_PATH]}/usr/lib/perl#{package.version.major}/vendor_perl/#{package.version}/#{System.host}#{'-thread' if features.threads?}",
      "-Dman1dir=#{System.env[:INSTALL_PATH]}/usr/share/man/man1", "-Dman3dir=#{System.env[:INSTALL_PATH]}/usr/share/man/man3",
      "-Dsiteman1dir=#{System.env[:INSTALL_PATH]}/usr/share/man/man1", "-Dsiteman3dir=#{System.env[:INSTALL_PATH]}/usr/share/man/man3",
      "-Dvendorman1dir=#{System.env[:INSTALL_PATH]}/usr/share/man/man1", "-Dvendorman3dir=#{System.env[:INSTALL_PATH]}/usr/share/man/man3",
      '-Dman1ext=1', '-Dman3ext=3pm', '-Dmyhostname=localhost', '-Dperladmin=root@localhost', '-Dinstallusrbinperl=n'
    )

    Packo.sh './Configure', *flags

    throw :halt
  end
}

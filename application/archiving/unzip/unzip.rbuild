Package.define('unzip') {
  behavior Behaviors::Standard

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'archiving'

  description 'unzipper for pkzip-compressed files'
  homepage    'http://www.info-zip.org/'
  license     'Info-ZIP'

  flavor {
    documentation {
      before :install do
        next if disabled? && !flavor.vanilla?

        package.do.man  'man/*.1'
        package.do.doc  'BUGS', 'History*', 'README', 'ToDo', 'WHERE'
      end
    }
  }
  
  features {
    bzip2 {
      before :compile do
        if enabled?
          environment[:CFLAGS] << ' -DUSE_BZIP2'
        end
      end
    }

    unicode {
      before :compile do
        if enabled?
          environment[:CFLAGS] << ' -DUNICODE_SUPPORT -DUNICODE_WCHAR -DUTF8_MAYBE_NATIVE'
        end
      end
    }
  }

  after :unpack do
    Do.cd "#{workdir}/unzip#{version.major}#{version.minor}"
  end

  after :patch do
    Do.sed('unix/Makefile',
      [/(CC|LD|AS)=gcc2?/, '\1=$(\1)'],
      [/CFLAGS=".*?"/,     'CFLAGS="$(CFLAGS)"']
    )
  end

  before :configure do
    throw :halt
  end

  before :compile do
    case target
      when 'i?686*-*linux*';   os = 'linux_asm'
      when '*linux*';          os = 'linux_noasm'
      when 'i?86*-*bsd*';      os = 'freebsd'
      when 'i?86*-dragonfly*'; os = 'bsd'
      when '*-darwin*';        os = 'macosx'
      else;                    os = nil
    end

    if !os
      raise RuntimeError.new('Unknown target')
    end

    if target == '*linux*'
      environment[:CFLAGS] << ' -DNO_LCHMOD'
    end

    environment[:CFLAGS] << ' -DLARGE_FILE_SUPPORT'

    autotools.make "-j#{environment[:MAKE_JOBS] || 1}", '-f', 'unix/Makefile', os

    throw :halt
  end

  before :install do
    package.do.bin 'unzip', 'funzip', 'unzipsfx', 'unix/zipgrep'
    package.do.sym 'unzip', '/usr/bin/zipinfo'

    throw :halt
  end
}

__END__
$$$

$$$ patches/unix/Makefile.patch $$$

--- Makefile.orig       2010-12-10 16:51:02.725907354 +0100
+++ Makefile    2010-12-10 16:54:35.330501165 +0100
@@ -42,17 +42,17 @@
 # such as -DDOSWILD).
 
 # UnZip flags
-CC = cc#	try using "gcc" target rather than changing this (CC and LD
+
 LD = $(CC)#	must match, else "unresolved symbol:  ___main" is possible)
-AS = as
+
 LOC = $(D_USE_BZ2) $(LOCAL_UNZIP)
 AF = $(LOC)
-CFLAGS = -O
+
 CF_NOOPT = -I. -I$(IZ_BZIP2) -DUNIX $(LOC)
 CF = $(CFLAGS) $(CF_NOOPT)
-LFLAGS1 =
+LFLAGS1 = $(LDFLAGS)
 LF = -o unzip$E $(LFLAGS1)
-LF2 = -s
+LF2 =

 # UnZipSFX flags
 SL = -o unzipsfx$E $(LFLAGS1)
@@ -70,7 +70,7 @@
 CHMOD = chmod
 BINPERMS = 755
 MANPERMS = 644
-STRIP = strip
+STRIP =
 E =
 O = .o
 M = unix

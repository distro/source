Package.define('pypy') {
  behavior Custom

  tags 'application', 'interpreter', 'development', 'python'

  description 'PyPy is a fast, compliant alternative implementation of the Python language.'
  homepage    'http://pypy.org/'
  license     'MIT'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://pypy.org/download/pypy-#{version}-src.tar.bz2'

  features {
    jit { enabled!
      before :configure do |conf|
        conf << "-O#{enabled? ? 'jit' : '2'}"
      end
    }

    sandbox {
      before :configure do |conf|
        conf << '--sandbox' if enabled?
      end
    }

    stackless {
      before :configure do |conf|
        conf << '--stackless' if enabled?
      end
    }

    ssl {
      before :configure do |conf|
        conf << "--with#{'out' if disabled?}mod-_ssl"
      end
    }

    ncurses {
      before :configure do |conf|
        conf << "--with#{'out' if disabled?}mod-_minimal_curses"
      end
    }

    xml {
      before :configure do |conf|
        conf << "--with#{'out' if disabled?}mod-pyexpat"

        if disabled?
          CLI.warn %{
            You have configured Python without XML support.
            This is NOT a recommended configuration as you
            may face problems parsing any XML documents.
          }
        end
      end
    }

    zlib {
      before :configure do |conf|
        conf << "--with#{'out' if disabled?}mod-zlib"
      end
    }

    bz2 {
      before :configure do |conf|
        conf << "--with#{'out' if disabled?}mod-bz2"
      end
    }
  }

  custom.configuration = []

  after :unpack do
    Do.cd "pypy-#{package.version}-src"
  end

  before :configure do |conf|
    conf.insert 1, './pypy/translator/goal/targetpypystandalone'
  end

  before :compile do |conf|
    if (System.host == /.86/ && !Requirements.memory(free: 1.5.GB)) || (System.host == 'x86_64' && !Requirements.memory(free: 2.5.GB))
      CLI.warn 'Not enough memory to build pypy, stuff could go REALLY wrong'
    end

    Packo.sh "python2 ./pypy/translator/goal/translate.py #{conf.join(' ')}"
  end

  before :install do |conf|
    package.do.into "/usr/lib/pypy#{package.slot}" do
      package.do.ins 'include', 'lib_pypy', 'lib-python'
      package.do.bin 'pypy-c'
    end

    package.do.sym "/usr/lib/pypy#{package.slot}/bin/pypy-c", "/usr/bin/pypy#{package.slot}"
  end
}

__END__
@@@

@@@ patches/disable-debugger.patch @@@

--- pypy/translator/goal/translate.py 2011-03-29 12:16:28.345000030 +0200
+++ pypy/translator/goal/translate.py_fixed 2011-03-29 12:17:26.196000030 +0200
@@ -248,7 +248,6 @@
             log.event("batch mode, not calling interactive helpers")
             return
         
-        log.event("start debugger...")
 
         if translateconfig.view:
             try:
@@ -259,7 +258,6 @@
             page = graphpage.TranslatorPage(t1, translateconfig.huge)
             page.display_background()
 
-        pdb_plus_show.start(tb)
 
     try:
         drv = driver.TranslationDriver.from_targetspec(targetspec_dic, config, args,

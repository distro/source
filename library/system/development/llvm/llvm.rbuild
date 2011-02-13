Package.define('llvm') {
  tags 'library', 'system', 'development'

  description 'Low Level Virtual Machine'
  homepage    'http://llvm.org'
  license     'UoI-NCSA'

  maintainer 'meh. <meh@paranoici.org>'

  source 'http://llvm.org/releases/#{package.version}/llvm-#{package.version}.tgz'

  features {
    optimizations { enabled!
      before :configure do |conf|
        conf.enable 'optimized', enabled?
      end
    }

    jit { enabled!
      before :configure do |conf|
        conf.enable 'jit', enabled?
      end
    }

    threads { enabled!
      before :configure do |conf|
        conf.enable 'thread', enabled?
      end
    }

    libffi { enabled!
      before :configure do |conf|
        conf.enable 'libffi', enabled?
      end
    }

    ocaml {
      before :configure do |conf|
        package.bindings << 'ocaml' if enabled?
      end
    }
  }

  before :initialize do
    package.bindings = []
  end

  before :configure do |conf|
    conf.with 'llvmgccdir', '/dev/null'
    conf.with 'llvmgcc',    'nope'
    conf.with 'llvmgxx',    'nope'

    conf.enable 'shared'
    conf.enable 'pic'
    conf.enable 'bindings', (bindings.empty? ? 'none' : bindings.join(','))

    conf.disable ['assertions', 'expensive-checks']

    conf.with 'c-include-dirs',   (env[:INSTALL_PATH] + '/usr/include').cleanpath
    conf.with 'cxx-include-root', (env[:INSTALL_PATH] + '/usr/include/g++v4').cleanpath
    conf.with 'cxx-include-arch', System.host.to_s
  end

  before :compile do |conf|
    autotools.make 'VERBOSE=1', 'KEEP_SYMBOLS=1', 'REQUIRES_RTTI=1'

    throw :halt
  end

  before :install do |conf|
    autotools.install nil, 'KEEP_SYMBOLS=1'

    throw :halt
  end
}

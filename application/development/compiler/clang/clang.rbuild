Package.define('clang') { type 'compilar'
  tags 'application', 'system', 'development', 'compiler'

  description 'C language family frontend for LLVM'
  homepage    'http://clang.llvm.org/'
  license     'UoI-NCSA'

  maintainer 'meh. <meh@paranoici.org>'

  dependencies << 'library/system/development/llvm'

  source 'http://llvm.org/releases/#{package.version}/llvm-#{package.version}.tgz', 'http://llvm.org/releases/#{package.version}/clang-#{package.version}.tgz'

  before :configure do |conf|
    conf.with 'llvmgccdir', '/dev/null'
    conf.with 'llvmgcc',    'nope'
    conf.with 'llvmgxx',    'nope'

    conf.enable 'shared'
    conf.enable 'pic'

    conf.disable ['assertions', 'expensive-checks']

    conf.with 'c-include-dirs',   (env[:INSTALL_PATH] + 'usr/include').cleanpath
    conf.with 'cxx-include-root', (env[:INSTALL_PATH] + 'usr/include/g++v4').cleanpath
    conf.with 'cxx-include-arch', System.host.to_s
  end

  after :unpack do
    package.unpack distfiles.last, workdir
    Do.mv "#{workdir}/clang-#{package.version}", "#{workdir}/llvm-#{package.version}/tools/clang"

    Do.cd "#{workdir}/llvm-#{package.version}"
  end

  before :compile do |conf|
    autotools.make 'VERBOSE=1', 'KEEP_SYMBOLS=1', 'REQUIRES_RTTI=1', 'clang-only'

    throw :halt
  end

  before :install do |conf|
    autotools.make 'KEEP_SYMBOLS=1', "DESTDIR=#{distdir}", 'install-clang'

    throw :halt
  end

}

Package.define('clang') {
  tags 'application', 'development', 'compiler'

  description 'C language family frontend for LLVM'
  homepage    'http://clang.llvm.org/'
  license     'UoI-NCSA'

  dependencies << 'library/system/development/llvm'

  source 'http://llvm.org/releases/#{package.version}/llvm-#{package.version}.tgz'

  before :configure do |conf|
    conf.with 'llvmgccdir', '/dev/null'
    conf.with 'llvmgcc',    'nope'
    conf.with 'llvmgxx',    'nope'

    conf.enable 'shared'
    conf.enable 'pic'

    conf.disable ['assertions', 'expensive-checks']

    conf.with 'c-include-dirs',   "#{System.env[:INSTALL_PATH]}/usr/include"
    conf.with 'cxx-include-root', "#{System.env[:INSTALL_PATH]}/usr/include/g++v4"
    conf.with 'cxx-include-arch', System.host.to_s
  end

  before :compile do |conf|
    autotools.make 'VERBOSE=1', 'KEEP_SYMBOLS=1', 'REQUIRES_RTTI=1', 'clang-only'

    throw :halt
  end

  before :install do |conf|
    autotools.install nil, 'KEEP_SYMBOLS=1'

    throw :halt
  end

}

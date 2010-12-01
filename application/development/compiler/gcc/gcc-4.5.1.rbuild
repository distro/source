Package.define('gcc', '4.5.1', '4.5') {
  arch     'x86', 'x86_64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc', 'newlib'

  autotools.version :autoconf, '2.64'

  after :unpack do
    if package.environment[:KERNEL] == 'windows'
      Modules::Fetching::Wget.fetch('http://mirrors.kernel.org/sourceware/cygwin/release/gcc4/gcc4-4.5.0-1-src.tar.bz2', "#{package.tempdir}/patches.tar.bz2")
      Modules::Misc::Unpack.do("#{package.tempdir}/patches.tar.bz2", "#{package.tempdir}/patches")

      [
        ['classpath-0.98-FIONREAD.patch', 2],
        ['classpath-0.98-build.patch',    2],
        ['classpath-0.98-awt.patch',      2],
        ['gcc45-ada.diff',                2],
        ['gcc45-cygwin-lto.diff',         0],
        ['gcc45-ehdebug.diff',            2],
        ['gcc45-libffi.diff',             2],
        ['gcc45-libstdc.diff',            2],
        ['gcc45-misc-core.diff',          2],
        ['gcc45-mnocygwin.diff',          2],
        ['gcc45-sig-unwind.diff',         0],
        ['gcc45-skiptest.diff',           2],
        ['gcc45-pruneopts-term.diff',     0],
        ['gcc45-weak-binding.diff',       2],
        ['gcc4-4.5.0-1.cygwin.patch',     2]
      ].each {|(file, level)|
        package.patch("#{package.tempdir}/patches/#{file}", :level => level) rescue nil
      }
    end
  end
}

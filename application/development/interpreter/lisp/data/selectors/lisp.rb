#! /usr/bin/env packo-selector-do

desc 'list', 'List available LISP versions'
def list
  CLI.info 'List of availaibale LISP versions'

  self.versions.each_with_index {|version, i|
    puts (self.current == version) ?
      "  {#{(i + 1).to_s.green}}    #{version}" :
      "  [#{i + 1             }]    #{version}"
  }
end

desc "set VERSION", 'Choose what version of LISP to use'
def set (version)
  versions = self.versions

  if version.numeric? && (version.to_i > versions.length || version.to_i < 1)
    fatal "#{version} out of index"
    exit 1
  end

  if version.numeric?
    version = versions[version.to_i - 1]
  end

  if !versions.member? version
    fatal "#{version} version not available for #{target}"
    exit 2
  end

  case version
    when 'ecl'
      FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/ecl").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/lisp").cleanpath) rescue nil

    when 'sbcl'
      FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/sbcl").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/lisp").cleanpath) rescue nil
  end

  CLI.info "Set LISP to #{version}"

  Models::Selector.first(:name => 'lisp').update(:data => version)
end

no_tasks {
  def current
    Models::Selector.first(:name => 'lisp').data rescue nil
  end

  def versions
    versions = []

    if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/ecl")
      versions << 'ecl'
    end

    if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/sbcl")
      versions << 'sbcl'
    end

    versions
  end
}

# lisp: Set the LISP version to use

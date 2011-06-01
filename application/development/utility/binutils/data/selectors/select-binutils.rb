#! /usr/bin/env ruby

desc 'list', 'List available binutils versions'
def list
  CLI.info 'List of availaibale binutils versions'

  current = self.current

  self.versions.each {|target, versions|
    next if versions.empty?

    puts ''
    puts target.blue.bold

    versions.each_with_index {|version, i|
      puts (current[target] == version) ?
        "  {#{(i + 1).to_s.green}}    #{version}" :
        "  [#{i + 1             }]    #{version}"
    }
  }
end

desc "set VERSION [TARGET=#{System.host}]", 'Choose what version of binutils to use'
def set (version, target=System.host.to_s)
  versions = self.versions[target]

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

  if target == System.host
    Dir["#{System.env![:INSTALL_PATH]}/usr/#{System.host}/binutils-bin/#{version}/*"].each {|file|
      FileUtils.ln_sf file, "#{System.env![:INSTALL_PATH]}/usr/bin/#{File.basename(file)}"
      FileUtils.ln_sf file, "#{System.env![:INSTALL_PATH]}/usr/bin/#{File.basename(file).sub("#{target.to_s}-", '')}"
    }
  else
    Dir["#{System.env![:INSTALL_PATH]}/usr/#{System.host}/#{target}/binutils-bin/#{version}/*"].each {|file|
      next unless File.basename(file).start_with?(target.to_s)

      FileUtils.ln_sf file, "#{System.env![:INSTALL_PATH]}/usr/bin/#{File.basename(file)}"
    }
  end

  CLI.info "Set binutils to #{version} for #{target}"

  Models::Selector.first(:name => 'binutils').update(:data => self.current.merge(target => version))
end

no_tasks {
  def current
    (Models::Selector.first(:name => 'binutils').data rescue nil) || {}
  end

  def versions
    versions = Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/*").select {|target|
      Host.parse(target.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/", '')) && !target.end_with?('-bin')
    }.map {|target|
      [target.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/", ''), Dir.glob("#{target}/binutils-bin/*").map {|version|
        version.sub("#{target}/binutils-bin/", '')
      }]
    }

    versions << [System.host.to_s, Dir.glob("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/binutils-bin/*").map {|version|
      version.sub("#{System.env![:INSTALL_PATH]}/usr/#{System.host}/binutils-bin/", '')
    }]

    Hash[versions]
  end
}

# binutils: Set the binutils version to use

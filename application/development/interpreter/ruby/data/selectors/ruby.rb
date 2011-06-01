#! /usr/bin/env packo-selector-do

desc 'list', 'List available Ruby versions'
def list
  CLI.info 'List of availaibale Ruby versions'

  current = self.current

  self.versions.each {|target, versions|
    next if versions.empty?

    if target == 'default'
      name = 'Default Ruby'
    else
      name = "Ruby #{target}"
    end

    puts ''
    puts name.blue.bold

    versions.each_with_index {|version, i|
      puts (current[target] == version) ?
        "  {#{(i + 1).to_s.green}}    #{version}" :
        "  [#{i + 1             }]    #{version}"
    }
  }

end

desc 'set VERSION [TARGET=default]', 'Choose what version of Ruby to use'
def set (version, target=:default)
  target   = normalize(target)
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

  place = case target
    when 'default' then ''
    when '1.8'     then '18'
    when '1.9'     then '19'
  end

  files = [:erb, :gem, :irb, :rake, :rdoc, :ri, :ruby, :testrb]

  case version
    when 'mri-1.8'
      files.each {|file|
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/#{file}1.8").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{file}#{place}").cleanpath) rescue nil
      }

    when 'mri-1.9'
      files.each {|file|
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/#{file}1.9").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{file}#{place}").cleanpath) rescue nil
      }

    when 'jruby'
      files.each {|file|
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + "/usr/bin/j#{file}").cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{file}#{place}").cleanpath) rescue nil
      }

    when 'rubinius'
      files.each {|file|
        FileUtils.ln_sf((System.env![:INSTALL_PATH] + '/usr/bin/rbx').cleanpath, (System.env![:INSTALL_PATH] + "/usr/bin/#{file}#{place}").cleanpath) rescue nil
      }        
  end

  CLI.info "Set Ruby to #{version}"

  Models::Selector.first(name: 'ruby').update(data: version)
end

no_tasks {
  def current
    Models::Selector.first(name: 'ruby').data rescue nil
  end

  def versions
    versions = { '1.8' => [], '1.9' => [] }

    if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/ruby1.8")
      versions['1.8'] << 'mri-1.8'
    end

    if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/ruby1.9")
      versions['1.9'] << 'mri-1.9'
    end

    if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/jruby")
      versions['1.8'] << 'jruby'
    end

    if File.executable?("#{System.env![:INSTALL_PATH]}/usr/bin/rbx")
      versions['1.8'] << 'rubinius'
    end

    versions['default'] = versions['1.8'] + versions['1.9']

    versions
  end

  def normalize (target)
    target = target.to_s

    if target.match(/1\.8/)
      '1.8'
    elsif target.to_s.match(/1\.9/)
      '1.9'
    else
      'default'
    end
  end
}

# ruby: Set the Ruby version to use

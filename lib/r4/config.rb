require 'yaml'

class Config

  def self.settings
    if File.exists? "#{ENV['HOME']}/.r4.yml"
      YAML::load_file("#{ENV['HOME']}/.r4.yml")
    else
      'You need to create ~/.r4.yml file, check github for example.'
    end
  end
end
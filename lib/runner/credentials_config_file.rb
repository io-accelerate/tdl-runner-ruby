require 'java-properties'


def read_from_config_file(key)
  properties = read_properties_file
  properties[key]
end

# noinspection RubyInstanceMethodNamingConvention
def read_from_config_file_with_default(key, default_value)
  properties = read_properties_file
  properties.fetch(key, default_value)
end

def read_properties_file
  begin
    JavaProperties.load('config/credentials.config')
  rescue StandardError => e
    puts 'Could not load config: ' + e.message
  end
end
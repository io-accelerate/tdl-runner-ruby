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
  JavaProperties.load('config/credentials.config')
end
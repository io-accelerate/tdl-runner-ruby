require 'java-properties'

def read_from_config_file(key)
  properties = JavaProperties.load('config/credentials.config')
  properties[key]
end
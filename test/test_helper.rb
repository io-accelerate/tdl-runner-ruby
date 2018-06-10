require 'require_all'

require 'simplecov'
SimpleCov.start

require 'simplecov-csv'
SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter

require_all File.join(File.dirname(__FILE__), '..', 'lib', 'solutions')

require 'minitest/autorun'

require 'logging'
Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :debug

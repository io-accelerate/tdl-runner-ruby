require 'simplecov'
SimpleCov.start

require 'simplecov-csv'
SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'solutions/SUM/sum'

require 'minitest/autorun'

require 'logging'
Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :debug

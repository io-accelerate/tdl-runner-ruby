$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'solutions/SUM/sum'

require 'minitest/autorun'

require 'logging'
Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :debug

require 'tdl'
require 'logging'
Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :info

require_relative '../../lib/runner/runner_action'
require_relative '../../lib/runner/credentials_config_file'
require_relative '../../lib/runner/recording_system'
require_relative '../../lib/runner/round_management'

include RunnerActions
include RecordingSystem
include RoundManagement

# ~~~~~~~~~ Setup ~~~~~~~~~

def start_client(argv, username, hostname, action_if_no_args, solutions)
  unless is_recording_system_ok
    puts('Please run `record_screen_and_upload` before continuing.')
    return
  end

  value_from_argv = extract_action_from(argv)
  runner_action = value_from_argv !=  nil ? value_from_argv : action_if_no_args
  puts("Chosen action is: #{runner_action.name}")

  client = TDL::Client.new(hostname: hostname, unique_id: username)

  rules = TDL::ProcessingRules.new
  rules.on('display_description')
      .call(RoundManagement.method(:display_and_save_description))
      .then(publish)

  solutions.each do |key, value|
    rules.on(key)
        .call(value)
        .then(runner_action.client_action)
  end

  client.go_live_with(rules)

  RecordingSystem.notify_event RoundManagement.get_last_fetched_round, runner_action.short_name
end

def extract_action_from(argv)
  first_arg = argv.length > 0 ? argv[0] : ''
  RunnerActions.all.select { |action| action.name.casecmp(first_arg) == 0 }.first
end

def is_recording_system_ok
  require_recording = true?(read_from_config_file_with_default(:tdl_require_rec, 'true'))

  if require_recording
    RecordingSystem.is_running
  else
    true
  end

end

def true?(obj)
  obj.to_s == 'true'
end

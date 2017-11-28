require 'tdl'
require 'logging'
Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :info

require_relative '../../lib/runner/runner_action'
require_relative '../../lib/runner/credentials_config_file'
require_relative '../../lib/runner/recording_system'
require_relative '../../lib/runner/round_management'
require_relative '../../lib/runner/challenge_server_client'

include RunnerActions
include RecordingSystem
include RoundManagement

# ~~~~~~~~~ Setup ~~~~~~~~~

def start_client(argv, username, hostname, action_if_no_args, solutions)
  unless is_recording_system_ok
    puts('Please run `record_screen_and_upload` before continuing.')
    return
  end

  puts("Connecting to #{hostname}.")

  if use_experimental_feature
    execute_server_action_from_user_input(argv, username, hostname, solutions)
  else
    execute_runner_action_from_args(argv, username, hostname, action_if_no_args, solutions)
  end
end

def extract_action_from(argv)
  first_arg = args.empty? ? argv[0] : ''
  RunnerActions.all.select { |action| action.name.casecmp(first_arg) == 0 }.first
end

def use_experimental_feature
  true?(read_from_config_file_with_default(:tdl_enable_experimental, 'false'))
end

def execute_server_action_from_user_input(argv, username, hostname, solutions)
  begin
    journey_id = read_from_config_file(:tdl_journey_id)
    use_colours = true?(read_from_config_file_with_default(:tdl_use_coloured_output, 'true'))
    challenge_server_client = ChallengeServerClient.new(hostname, journey_id, use_colours)
    journey_progress = challenge_server_client.get_journey_progress
    puts(journey_progress)
    available_actions = challenge_server_client.get_available_actions
    puts(available_actions)

    return if available_actions.include? 'No actions available.'
    user_input = get_user_input(argv)
    if user_input == 'deploy'
      execute_runner_action(hostname, RunnerActions.deploy_to_production, solutions, username)
    end

    action_feedback = challenge_server_client.send_action(user_input)
    puts(action_feedback)

    response_string = challenge_server_client.get_round_description
    RoundManagement.save_description(
      response_string,
      ->(x) { RecordingSystem.notify_event(x, RunnerActions.get_new_round_description.short_name) }
    )
  rescue ChallengeServerClient::ClientErrorException => e
    puts('The client sent something the server didn\'t expect.')
    puts(e.message)
  rescue ChallengeServerClient::ServerErrorException => e
    puts('Server experienced an error. Try again.')
    puts(e.message)
  rescue ChallengeServerClient::OtherCommunicationException => e
    puts('Client threw an unexpected error.')
    puts(e.message)
  end
end

def get_user_input(args)
  args.empty? ? gets.chomp : args[0]
end

def execute_runner_action_from_args(argv, username, hostname, action_if_no_args, solutions)
  value_from_argv = extract_action_from(argv)
  runner_action = value_from_argv != nil ? value_from_argv : action_if_no_args
  execute_runner_action(hostname, runner_action, solutions, username)
end

def execute_runner_action(hostname, runner_action, solutions, username)
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

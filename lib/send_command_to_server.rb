require 'tdl'
require_relative './runner/user_input_action'
require_relative './runner/utils'
require_relative 'entry_point_mapping'

include Utils

require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

#
# ~~~~~~~~~~ Running the system: ~~~~~~~~~~~~~
#
#   From IDE:
#      Run this file from the IDE. Set the working directory to the root of the repo.
#
#   From command line:
#      rake run
#
#   To run your unit tests locally:
#      rake
#
# ~~~~~~~~~~ The workflow ~~~~~~~~~~~~~
#
#   By running this file you interact with a challenge server.
#   The interaction follows a request-response pattern:
#        * You are presented with your current progress and a list of actions.
#        * You trigger one of the actions by typing it on the console.
#        * After the action feedback is presented, the execution will stop.
#
#   +------+-----------------------------------------------------------------------+
#   | Step | The usual workflow                                                    |
#   +------+-----------------------------------------------------------------------+
#   |  1.  | Run this file.                                                        |
#   |  2.  | Start a challenge by typing "start".                                  |
#   |  3.  | Read the description from the "challenges" folder.                    |
#   |  4.  | Locate the file corresponding to your current challenge in:           |
#   |      |   ./lib/solutions                                                     |
#   |  5.  | Replace the following placeholder exception with your solution:       |
#   |      |   raise 'Not implemented'                                             |
#   |  6.  | Deploy to production by typing "deploy".                              |
#   |  7.  | Observe the output, check for failed requests.                        |
#   |  8.  | If passed, go to step 1.                                              |
#   +------+-----------------------------------------------------------------------+
#
#   You are encouraged to change this project as you please:
#        * You can use your preferred libraries.
#        * You can use your own test framework.
#        * You can change the file structure.
#        * Anything really, provided that this file stays runnable.
#
#
# noinspection RubyStringKeysInHashInspection

entry_point_mapping = EntryPointMapping.new

runner = TDL::QueueBasedImplementationRunnerBuilder.new
  .set_config(Utils.get_runner_config)
  .with_solution_for('amazing_maze', entry_point_mapping.method(:amazing_maze))
  .with_solution_for('array_sum', entry_point_mapping.method(:array_sum))
  .with_solution_for('checkout', entry_point_mapping.method(:checkout))
  .with_solution_for('count_lines', entry_point_mapping.method(:count_lines))
  .with_solution_for('filter_pass', entry_point_mapping.method(:filter_pass))
  .with_solution_for('fizz_buzz', entry_point_mapping.method(:fizz_buzz))
  .with_solution_for('hello', entry_point_mapping.method(:hello))
  .with_solution_for('increment', entry_point_mapping.method(:increment))
  .with_solution_for('int_range', entry_point_mapping.method(:int_range))
  .with_solution_for('inventory_add', entry_point_mapping.method(:inventory_add))
  .with_solution_for('inventory_get', entry_point_mapping.method(:inventory_get))
  .with_solution_for('inventory_size', entry_point_mapping.method(:inventory_size))
  .with_solution_for('letter_to_santa', entry_point_mapping.method(:letter_to_santa))
  .with_solution_for('rabbit_hole', entry_point_mapping.method(:rabbit_hole))
  .with_solution_for('render_house', entry_point_mapping.method(:render_house))
  .with_solution_for('sum', entry_point_mapping.method(:sum))
  .with_solution_for('to_uppercase', entry_point_mapping.method(:to_uppercase))
  .with_solution_for('ultimate_maze', entry_point_mapping.method(:ultimate_maze))
  .with_solution_for('waves', entry_point_mapping.method(:waves))
  .create


TDL::ChallengeSession
    .for_runner(runner)
    .with_config(Utils.get_config)
    .with_action_provider(UserInputAction.new(ARGV))
    .start

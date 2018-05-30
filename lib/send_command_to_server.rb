require 'tdl'
require_relative './runner/user_input_action'
require_relative './runner/utils'

require_relative './solutions/CHK/checkout'
require_relative './solutions/FIZ/fizz_buzz'
require_relative './solutions/HLO/hello'
require_relative './solutions/SUM/sum'

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
#      rake test
#
# ~~~~~~~~~~ The workflow ~~~~~~~~~~~~~
#
#   By running this file you interact with a challenge server.
#   The interaction follows a request-response pattern:
#        * You are presented with your current progress and a list of actions.
#        * You trigger one of the actions by typing it on the console.
#        * After the action feedback is presented, the execution will stop.
#
#   +------+-------------------------------------------------------------+
#   | Step | The usual workflow                                          |
#   +------+-------------------------------------------------------------+
#   |  1.  | Run this file.                                              |
#   |  2.  | Start a challenge by typing "start".                        |
#   |  3.  | Read description from the "challenges" folder               |
#   |  4.  | Implement the required method in                            |
#   |      |   ./lib/solutions                                           |
#   |  5.  | Deploy to production by typing "deploy".                    |
#   |  6.  | Observe output, check for failed requests.                  |
#   |  7.  | If passed, go to step 3.                                    |
#   +------+-------------------------------------------------------------+
#
#   You are encouraged to change this project as you please:
#        * You can use your preferred libraries.
#        * You can use your own test framework.
#        * You can change the file structure.
#        * Anything really, provided that this file stays runnable.
#
#
# noinspection RubyStringKeysInHashInspection

runner = TDL::QueueBasedImplementationRunnerBuilder.new
    .set_config(Utils.get_runner_config)
    .with_solution_for('sum', -> (x, y) {Sum.new.sum(x, y)})
    .with_solution_for('hello', -> (p) {Hello.new.hello(p)})
    .with_solution_for('fizz_buzz', -> (p) {FizzBuzz.new.fizz_buzz(p)})
    .with_solution_for('checkout', -> (p) {Checkout.new.checkout(p)})
    .create

TDL::ChallengeSession
    .for_runner(runner)
    .with_config(Utils.get_config)
    .with_action_provider(UserInputAction.new(ARGV))
    .start


require_relative '../lib/runner/client_runner'
require_relative '../lib/runner/runner_action'
require_relative '../lib/runner/credentials_config_file'

include RunnerActions

#
# ~~~~~~~~~~ The workflow ~~~~~~~~~~~~~
#
#   +------+-----------------------------------------+-----------------------------------------------+
#   | Step |          IDE                            |         Web console                           |
#   +------+-----------------------------------------+-----------------------------------------------+
#   |  1.  |                                         | Open your browser and go to:                  |
#   |      |                                         |    http://run.befaster.io:8111                |
#   |  2.  |                                         | Configure your email                          |
#   |  3.  |                                         | Start a challenge, should display "Started"   |
#   |  4.  | Set the email variable                  |                                               |
#   |  5.  | Run "get_new_round_description"         |                                               |
#   |  6.  | Read description from ./challenges      |                                               |
#   |  7.  | Implement the required method in        |                                               |
#   |      |   ./lib/solutions                       |                                               |
#   |  8.  | Run "test_connectivity", observe output |                                               |
#   |  9.  | If ready, run "deploy_to_production"    |                                               |
#   | 10.  |                                         | Type "done"                                   |
#   | 11.  |                                         | Check failed requests                         |
#   | 12.  |                                         | Go to step 5.                                 |
#   +------+-----------------------------------------+-----------------------------------------------+
#
# ~~~~~~~~~~ Running the system: ~~~~~~~~~~~~~
#
#   From command line:
#      rake run action=$ACTION
#
#   From IDE:
#      Set the value of the `action_if_no_args`
#      Run this file from the IDE.
#
#   Available actions:
#        * get_new_round_description - Get the round description (call once per round).
#        * test_connectivity         - Test you can connect to the server (call any number of time)
#        * deploy_to_production      - Release your code. Real requests will be used to test your solution.
#                                      If your solution is wrong you get a penalty of 10 minutes.
#                                      After you fix the problem, you should deploy a new version into production.
#
start_client(ARGV,
             username=read_from_config_file(:tdl_username),
             hostname='run.befaster.io',
             action_if_no_args=test_connectivity)
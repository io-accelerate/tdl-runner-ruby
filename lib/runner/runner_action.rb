
include TDL::ClientActions

class RunnerAction
  attr_reader :short_name, :name, :client_action

  def initialize(short_name, name, client_action)
    @short_name = short_name
    @name = name
    @client_action = client_action
  end

end

module RunnerActions
  def get_new_round_description
    RunnerAction.new('new', 'get_new_round_description', stop)
  end

  def test_connectivity
    RunnerAction.new('test', 'test_connectivity', stop)
  end

  def deploy_to_production
      RunnerAction.new('deploy', 'deploy_to_production', publish)
  end

  def all
    [get_new_round_description, test_connectivity, deploy_to_production]
  end
end

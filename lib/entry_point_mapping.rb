require_relative 'solutions/sum/sum_solution'
require_relative 'solutions/hlo/hello_solution'
require_relative 'solutions/fiz/fizz_buzz_solution'
require_relative 'solutions/chk/checkout_solution'
require_relative 'solutions/dmo/demo_round1_solution'
require_relative 'solutions/dmo/demo_round2_solution'
require_relative 'solutions/dmo/demo_round3_solution'
require_relative 'solutions/dmo/inventory_item'
require_relative 'solutions/dmo/demo_round4n5_solution'

class EntryPointMapping
  def initialize
    @sum_solution = SumSolution.new
    @hello_solution = HelloSolution.new
    @fizz_buzz_solution = FizzBuzzSolution.new
    @checkout_solution = CheckoutSolution.new
    @demo_round1_solution = DemoRound1Solution.new
    @demo_round2_solution = DemoRound2Solution.new
    @demo_round3_solution = DemoRound3Solution.new
    @demo_round4n5_solution = DemoRound4n5Solution.new
  end

  # Round 0
  def sum(*args)
    @sum_solution.compute(*args)
  end

  def hello(*args)
    @hello_solution.hello(*args)
  end

  def fizz_buzz(*args)
    @fizz_buzz_solution.fizz_buzz(*args)
  end

  def checkout(*args)
    @checkout_solution.checkout(*args)
  end

  # Round 1
  def increment(*args)
    @demo_round1_solution.increment(*args)
  end

  def to_uppercase(*args)
    @demo_round1_solution.to_uppercase(*args)
  end

  def letter_to_santa
    @demo_round1_solution.letter_to_santa
  end

  def count_lines(*args)
    @demo_round1_solution.count_lines(*args)
  end

  # Round 2
  def array_sum(*args)
    @demo_round2_solution.array_sum(*args)
  end

  def int_range(*args)
    @demo_round2_solution.int_range(*args)
  end

  def filter_pass(*args)
    @demo_round2_solution.filter_pass(*args)
  end

  # Round 3
  def inventory_add(inventory_item_hash, number)
    item = InventoryItem.new(**inventory_item_hash)
    @demo_round3_solution.inventory_add(item, number)
  end

  def inventory_size
    @demo_round3_solution.inventory_size
  end

  def inventory_get(*args)
    response = @demo_round3_solution.inventory_get(*args)
    object_to_hash(response)
  end

  # Round 4 & 5
  def waves(*args)
    @demo_round4n5_solution.waves(*args)
  end
  
  # ~~~~~~~~~~ Helpers ~~~~~~~~~~~~~
  def object_to_hash(obj)
    obj.instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete("@")] = obj.instance_variable_get(var)
    end
  end
end

# frozen_string_literal: true

require_relative 'mini_r_spec/base'
require_relative 'mini_r_spec/context'
require_relative 'mini_r_spec/describe_leaf'
require_relative 'mini_r_spec/it_leaf'
require_relative 'mini_r_spec/match_error'
require_relative 'mini_r_spec/matchers'
require_relative 'mini_r_spec/test_manager'

module MiniRSpec
  def self.describe(title, &block)
    unit = Base.new
    leaf = DescribeLeaf.new(title)
    leaf.instance_exec(&block)
    unit.ast << leaf
    # unit.show_ast
    # puts ''
    # unit.print_cases
    # puts ''
    unit.run_tests
    unit
  end
end


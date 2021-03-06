# frozen_string_literal: true

require_relative 'mini_r_spec/base'
require_relative 'mini_r_spec/context'
require_relative 'mini_r_spec/describe_leaf'
require_relative 'mini_r_spec/it_leaf'
require_relative 'mini_r_spec/match_error'
require_relative 'mini_r_spec/matchers'
require_relative 'mini_r_spec/test_manager'

module MiniRSpec
  # Initialize describe leaf and store data in the base object
  def self.describe(title, &block)
    unit = Base.instance
    leaf = DescribeLeaf.new(title)
    leaf.instance_exec(&block)
    unit.ast << leaf
    unit
  end

  def self.run_tests
    unit = Base.instance
    unit.run_tests
    unit.clean_ast!
    unit
  end
end


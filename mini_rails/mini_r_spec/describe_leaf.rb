# frozen_string_literal: true

module MiniRSpec
  # NOTE: `describe` leaf
  class DescribeLeaf
    include Context
    attr_reader :title
    attr_accessor :children

    def initialize(title)
      @title = title
      @children = []
      @callbacks = [] # Array for before_each callbacks
      @variables = {} # Hash for let! data
    end

    # @return [Array<String>]
    def show_title
      titles = []
      children.each do |node|
        if node.is_a?(ItLeaf::Base)
          titles << node.show_title
        elsif node.is_a?(DescribeLeaf)
          node.show_title.each do |str|
            titles << "#{node.title} #{str}"
          end
        else
          raise "ERROR: Undefined node #{node}"
        end
      end
      titles
    end

    # TODO: Implement lazy let
    # @param variable_name [String, Symbol]
    def let!(variable_name, &block)
      @variables[variable_name.to_sym] = block
    end

    def before_each(&block)
      @callbacks.push(block)
    end

    # @param context [String]
    # @param before_callbacks [Array<Proc>]
    # @param variables [Hash<Symbol, Proc>]
    def run_tests(context = nil, before_callbacks = [], variables = {})
      context = [context, title].compact.join(' ')
      merged_callbacks = before_callbacks + @callbacks
      merged_variables = variables.merge(@variables)

      children.each do |node|
        if node.is_a?(ItLeaf::Base)
          node.run_tests(context, merged_callbacks, merged_variables)
        elsif node.is_a?(DescribeLeaf)
          node.run_tests(context, merged_callbacks, merged_variables)
        else
          raise "ERROR: Undefined node #{node}"
        end
      end
    end

    # @described_object [String, Object] Object must respond to method .to_s
    # @return [DescribeLeaf]
    def describe(described_object, &block)
      leaf = super
      @children << leaf
      nil
    end

    # NOTE: Rewrite aliase
    alias_method :context, :describe

    # @described_object [String, Object] Object must respond to method .to_s
    # @return [ItLeaf::Base]
    def it(described_object = '', &block)
      leaf = super
      @children << leaf
      nil
    end
  end
end

# frozen_string_literal: true

require 'singleton'

module MiniRSpec
  # Singleton class to store test data as AST in @ast variable
  class Base
    attr_accessor :ast

    include ::Singleton

    def initialize
      @ast = []
    end

    def show_ast
      @ast.each do |i|
        puts i.inspect
        puts ''
      end
    end

    def clean_ast!
      @ast = []
    end

    def print_cases
      titles = []
      @ast.each do |node|
        if node.is_a?(ItLeaf::Base)
          titles << node.show_title
        elsif node.is_a?(DescribeLeaf)
          node.show_title.each do |title|
            titles << "#{node.title} #{title}"
          end
        else
          raise "ERROR: Undefined node #{node}"
        end
      end
      puts titles
    end

    def run_tests
      puts ''
      TestManager.instance.reset_stat!
      @ast.each do |node|
        if node.is_a?(ItLeaf::Base)
          node.run_tests
        elsif node.is_a?(DescribeLeaf)
          node.run_tests
        else
          raise "ERROR: Undefined node #{node}"
        end
      end
      TestManager.instance.show_stat
    end
  end
end

# frozen_string_literal: true

require 'pry'
require 'singleton'

class MatchError < StandardError
end

class Matcher
  def initialize(value)
    @value = value
  end

  def to(matcher)
    matcher == @value
  end

  def to_not(matcher)
    matcher != @value
  end
end

class EqMatcher < Matcher
  def ==(new_value)
    a = @value == new_value
    message = "'#{new_value}' not to equal '#{@value}'"
    raise ::MatchError, message if a == false
    a
  end

  def !=(new_value)
    a = @value != new_value
    message = "'#{new_value}' to equal '#{@value}'"
    raise ::MatchError, message if a == false
    a
  end
end


module Matchers
  def expect(object)
    Matcher.new(object)
  end

  def eq(object)
    EqMatcher.new(object)
  end
end


class TestManager
  include ::Singleton

  attr_reader :info

  def initialize
    @info = {
      success: [],
      failure: []
    }
  end

  def add_success(context)
    @info[:success] << context
  end

  def add_failure(context, exception)
    @info[:failure] << [context, exception]
  end

  def reset_stat!
    @info[:success] = []
    @info[:failure] = []
    nil
  end

  def show_stat
    success = @info[:success].size
    failure = @info[:failure].size
    all = success + failure

    puts "Finished: #{all} examples, #{failure} failures"

    return if failure == 0

    puts "Failures:\n\r"

    @info[:failure].each_with_index do |arr, index|
      context, exc = arr
      puts "  #{index+1}) #{context}"
      puts '    Failure/Error: expect(StringCalculator.add("")).to eq(0)'
      puts ''
      puts "    #{exc.class}:"
      puts "      #{exc.message}"
      puts "    # ./spec/string_calculator_spec.rb:8:in `block (4 levels) in <top (required)>'"
    end
  end
end


module A
  # @described_object [String, Object] Object must respond to method .to_s
  # @return [DescribeLeaf]
  def describe(described_object, &block)
    leaf = DescribeLeaf.new(described_object)
    leaf.instance_exec(&block)
    leaf
  end

  # @described_object [String, Object] Object must respond to method .to_s
  # @return [ItLeaf]
  def it(described_object, &block)
    leaf = ItLeaf.new(described_object)
    leaf.proc = block
    leaf
  end
end


class ItLeaf
  include A
  include Matchers
  attr_reader :title
  attr_accessor :proc

  def initialize(title)
    @title = title
    @proc = nil
  end

  def show_title
    title
  end

  # Как понять сколько было тест кейсов?
  # Test observer
  # @param context [String]
  def run_tests(context = nil)
    context = [context, title].compact.join(' ')
    return nil if @proc.nil?

    result = instance_exec(&@proc)
    TestManager.instance.add_success(context)
  rescue ::StandardError => e
    TestManager.instance.add_failure(context, e)
  end

  def describe(described_object)
    raise 'Can not use describe inside "it" block'
  end
end

class DescribeLeaf
  include A
  attr_reader :title
  attr_accessor :children

  def initialize(title)
    @title = title
    @children = []
  end

  # @return [Array<String>]
  def show_title
    titles = []
    children.each do |node|
      if node.is_a?(ItLeaf)
        titles << node.show_title
      elsif node.is_a?(DescribeLeaf)
        node.show_title.each do |str|
          titles << "#{node.title} #{str}"
        end
      else
        raise "Undefined node #{node}"
      end
    end
    titles
  end

  # @param context [String]
  def run_tests(context = nil)
    context = [context, title].compact.join(' ')
    children.each do |node|
      if node.is_a?(ItLeaf)
        node.run_tests(context)
      elsif node.is_a?(DescribeLeaf)
        node.run_tests(context)
      else
        raise "Undefined node #{node}"
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

  # @described_object [String, Object] Object must respond to method .to_s
  # @return [ItLeaf]
  def it(described_object, &block)
    leaf = super
    @children << leaf
    nil
  end
end

# 1: Use instance_exect https://www.codewithjason.com/ruby-instance-exec/
class MiniRSpec
  attr_accessor :ast

  def initialize
    @ast = [] # TODO: replace with node
  end

  def show_ast
    @ast.each do |i|
      puts i.inspect
      puts ''
    end
  end

  def print_cases
    titles = []
    @ast.each do |node|
      if node.is_a?(ItLeaf)
        titles << node.show_title
      elsif node.is_a?(DescribeLeaf)
        node.show_title.each do |title|
          titles << "#{node.title} #{title}"
        end
      else
        raise "Undefined node #{node}"
      end
    end
    puts titles
  end

  def run_tests
    puts ''
    TestManager.instance.reset_stat!
    @ast.each do |node|
      if node.is_a?(ItLeaf)
        node.run_tests
      elsif node.is_a?(DescribeLeaf)
        node.run_tests
      else
        raise "Undefined node #{node}"
      end
    end
    TestManager.instance.show_stat
  end

  def self.describe(title, &block)
    unit = new
    leaf = DescribeLeaf.new(title)
    leaf.instance_exec(&block)
    unit.ast << leaf
    unit
  end
end


unit = MiniRSpec.describe 'TestCases' do
  describe 'Describe1' do
    it 'D1-1' do
      expect(1).to eq(1)
    end
    it 'D1-2' do
      expect(1).to eq(1)
    end
  end

  describe 'Describe2' do
    it 'D2-1' do
      expect(1).to eq(1)
    end
    it 'D2-2' do
      expect(1).to eq(1)
    end
    describe 'Describe2.1' do
      it 'D2.1-1' do
        expect(1).to_not eq(1)
      end
    end
  end
end


unit.show_ast
puts ''
unit.print_cases
puts ''
unit.run_tests

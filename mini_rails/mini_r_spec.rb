# frozen_string_literal: true

require 'pry'

class MatchError < StandardError
end

class Matcher
end

# TODO: implement singleton
class TestObserver
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
    puts context
    return nil if @proc.nil?

    result = @proc&.call
    if result == false
      # raise MatchError, "False result for: #{context}"
    end
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

# 1: User instance_exect https://www.codewithjason.com/ruby-instance-exec/
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
    @ast.each do |node|
      if node.is_a?(ItLeaf)
        node.run_tests
      elsif node.is_a?(DescribeLeaf)
        node.run_tests
      else
        raise "Undefined node #{node}"
      end
    end
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
      1 + 1
    end
    it 'D1-2' do
      1 + 1
    end
  end

  describe 'Describe2' do
    it 'D2-1' do
      1 + 1
    end
    it 'D2-2' do
      1 + 1
    end
    describe 'Describe2.1' do
      it 'D2.1-1' do
        false
      end
    end
  end
end


unit.show_ast
puts ''
unit.print_cases
puts ''
unit.run_tests

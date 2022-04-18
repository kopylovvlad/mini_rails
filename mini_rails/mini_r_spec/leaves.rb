# frozen_string_literal: true

module MiniRSpec
  class ItLeaf
    include Context

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

    def expect(object)
      Matcher.new(object)
    end

    def eq(object)
      EqMatcher.new(object)
    end

    def be_truthy
      eq(true)
    end

    def be_falsey
      eq(false)
    end

    def be_nil
      eq(nil)
    end

    def be_instance_of(object)
      BeInstanceOfMatcher.new(object)
    end

    alias_method :be_kind_of, :be_instance_of

    def include(object)
      IncludeMatcher.new(object)
    end
  end

  class DescribeLeaf
    include Context
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
end

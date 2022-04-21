# frozen_string_literal: true

module MiniRSpec
  # TODO: define xit and xdescribe
  module Context
    # @param described_object [String, Object] Object must respond to method .to_s
    # @return [DescribeLeaf]
    def describe(described_object, &block)
      leaf = DescribeLeaf.new(described_object)
      leaf.instance_exec(&block)
      leaf
    end

    alias_method :context, :describe

    # @param described_object [String, Object] Object must respond to method .to_s
    # @return [ItLeaf]
    def it(described_object, &block)
      leaf = ItLeaf.new(described_object)
      leaf.proc = block
      leaf
    end
  end
end

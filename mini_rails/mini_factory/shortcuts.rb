# frozen_string_literal: true

module MiniFactory
  module Shortcuts
    def build(*args)
      ::MiniFactory.build(*args)
    end

    def build_list(*args)
      ::MiniFactory.build_list(*args)
    end

    def create(*args)
      ::MiniFactory.create(*args)
    end

    def create_list(*args)
      ::MiniFactory.create_list(*args)
    end
  end
end

# frozen_string_literal: true

require "rack/test"

module MiniRSpec
  module ItLeaf
    module RequestHelper
      include ::Rack::Test::Methods

      def app
        ::MiniActionDispatch::RequestHandler.new
      end

      def json
        JSON.parse(last_response.body)
      end

      alias_method :response, :last_response

      def have_http_status(number)
        HaveHttpStatusMatcher.new(number)
      end
    end
  end
end

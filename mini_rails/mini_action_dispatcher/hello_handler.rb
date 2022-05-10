# frozen_string_literal: true

module MiniActionDispatch
  # Rack-middleware to render hello world page
  class HelloHandler
    def call(env)
      [200, { "Content-Type" => 'text/html' }, [body]]
    end

    private

    def body
      <<~MSG
        <h1>Hello to Ruby on MiniRails</h1>
      MSG
    end
  end
end

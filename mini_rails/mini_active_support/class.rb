# frozen_string_literal: true

module MiniActiveSupport
  module Class
    # https://apidock.com/rails/Class/class_attribute
    def class_attribute(*attrs, instance_accessor: true,
      instance_reader: instance_accessor, instance_writer: instance_accessor, instance_predicate: true, default: nil)

      class_methods, methods = [], []
      attrs.each do |name|
        unless name.is_a?(Symbol) || name.is_a?(String)
          raise TypeError, "#{name.inspect} is not a symbol nor a string"
        end

        class_methods << <<~RUBY # In case the method exists and is not public
          silence_redefinition_of_method def #{name}
          end
        RUBY

        methods << <<~RUBY if instance_reader
          silence_redefinition_of_method def #{name}
            defined?(@#{name}) ? @#{name} : self.class.#{name}
          end
        RUBY

        class_methods << <<~RUBY
          silence_redefinition_of_method def #{name}=(value)
            redefine_method(:#{name}) { value } if singleton_class?
            redefine_singleton_method(:#{name}) { value }
            value
          end
        RUBY

        methods << <<~RUBY if instance_writer
          silence_redefinition_of_method(:#{name}=)
          attr_writer :#{name}
        RUBY

        if instance_predicate
          class_methods << "silence_redefinition_of_method def #{name}?; !!self.#{name}; end"
          if instance_reader
            methods << "silence_redefinition_of_method def #{name}?; !!self.#{name}; end"
          end
        end
      end

      location = caller_locations(1, 1).first
      class_eval(["class << self", *class_methods, "end", *methods].join(";").tr("\n", ";"), location.path, location.lineno)

      attrs.each { |name| public_send("#{name}=", default) }
    end

    # https://apidock.com/rails/v5.2.3/Class/descendants
    def descendants
      descendants = []
      ObjectSpace.each_object(singleton_class) do |k|
        next if k.singleton_class?
        descendants.unshift k unless k == self
      end
      descendants
    end
  end
end

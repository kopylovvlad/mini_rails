# frozen_string_literal: true

module MiniActiveSupport
  # It converts all strings to symbols
  class HashWithIndifferentAccess
    def initialize(hash)
      @raw_hash = hash.map do |key, value|
        key = key.to_sym if key.is_a?(::String)
        value = new(value) if value.is_a?(::Hash)

        { key => value }
      end.reduce(:merge)
    end

    # @param key [String, Symbol]
    def [](key)
      if key.is_a?(::String)
        @raw_hash[key.to_sym]
      else
        @raw_hash[key]
      end
    end

    # @param key [String, Symbol]
    def include?(key)
      if key.is_a?(::String)
        @raw_hash.include?(key.to_sym)
      else
        @raw_hash.include?(key)
      end
    end

    alias_method :key?, :include?
    alias_method :has_key?, :include?

    def to_h
      @raw_hash
    end

    private

    def method_missing(message, *args, &block)
      if @raw_hash.respond_to?(message)
        @raw_hash.send(message, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @raw_hash.respond_to?(method_name, include_private) || super
    end
  end
end

class String
  def camelize(uppercase_first_letter = true)
    string = self
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
    else
      string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
    end
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub("/", "::")
  end

  def snakecase
    camel_cased_word = self
    return camel_cased_word unless /[A-Z-]|::/.match?(camel_cased_word)

    word = camel_cased_word.to_s.gsub("::".freeze, "/".freeze)
    # word.gsub!(inflections.acronyms_underscore_regex) { "#{$1 && '_'.freeze }#{$2.downcase}" }
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
    word.tr!("-".freeze, "_".freeze)
    word.downcase!
    word
  end
end

class Module
  # Marks the named method as intended to be redefined, if it exists.
  # Suppresses the Ruby method redefinition warning. Prefer
  # #redefine_method where possible.
  def silence_redefinition_of_method(method)
    if method_defined?(method) || private_method_defined?(method)
      # This suppresses the "method redefined" warning; the self-alias
      # looks odd, but means we don't need to generate a unique name
      alias_method method, method
    end
  end

  # Replaces the existing method definition, if there is one, with the passed
  # block as its body.
  def redefine_method(method, &block)
    visibility = method_visibility(method)
    silence_redefinition_of_method(method)
    define_method(method, &block)
    send(visibility, method)
  end

  # Replaces the existing singleton method definition, if there is one, with
  # the passed block as its body.
  def redefine_singleton_method(method, &block)
    singleton_class.redefine_method(method, &block)
  end

  def method_visibility(method) # :nodoc:
    case
    when private_method_defined?(method)
      :private
    when protected_method_defined?(method)
      :protected
    else
      :public
    end
  end
end

class Class
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
end

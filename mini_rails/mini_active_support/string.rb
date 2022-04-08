# frozen_string_literal: true

module MiniActiveSupport
  module String
    # https://apidock.com/rails/ActiveSupport/Inflector/camelize
    def camelize(uppercase_first_letter = true)
      string = self
      if uppercase_first_letter
        string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
      else
        string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
      end
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub("/", "::")
    end

    # https://apidock.com/rails/v5.2.3/ActiveSupport/Inflector/underscore
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

    def to_bool
      if self == 'true'
        true
      else
        false
      end
    end

    def present?
      self.size > 0
    end

    # @return [String]
    def as_json
      self
    end

    # @return [String]
    def to_json
      self
    end
  end
end


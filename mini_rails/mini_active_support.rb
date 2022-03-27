# frozen_string_literal: true

require_relative 'mini_active_support/array'
require_relative 'mini_active_support/class'
require_relative 'mini_active_support/date_time'
require_relative 'mini_active_support/hash'
require_relative 'mini_active_support/hash_with_indifferent_access'
require_relative 'mini_active_support/module'
require_relative 'mini_active_support/nil_class'
require_relative 'mini_active_support/numeric'
require_relative 'mini_active_support/string'

Array.send(:prepend, MiniActiveSupport::Array)
Class.send(:prepend, MiniActiveSupport::Class)
DateTime.send(:prepend, MiniActiveSupport::DateTime)
Hash.send(:prepend, MiniActiveSupport::Hash)
Module.send(:prepend, MiniActiveSupport::Module)
NilClass.send(:prepend, MiniActiveSupport::NilClass)
Numeric.send(:prepend, MiniActiveSupport::Numeric)
String.send(:prepend, MiniActiveSupport::String)

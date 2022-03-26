# frozen_string_literal: true

require_relative 'mini_active_support/array'
require_relative 'mini_active_support/class'
require_relative 'mini_active_support/hash'
require_relative 'mini_active_support/hash_with_indifferent_access'
require_relative 'mini_active_support/module'
require_relative 'mini_active_support/numeric'
require_relative 'mini_active_support/string'

Array.send(:prepend, MiniActiveSupport::Array)
Class.send(:prepend, MiniActiveSupport::Class)
Hash.send(:prepend, MiniActiveSupport::Hash)
Module.send(:prepend, MiniActiveSupport::Module)
Numeric.send(:prepend, MiniActiveSupport::Numeric)
String.send(:prepend, MiniActiveSupport::String)

# frozen_string_literal: true

require_relative 'mini_active_support/class'
require_relative 'mini_active_support/hash_with_indifferent_access'
require_relative 'mini_active_support/module'
require_relative 'mini_active_support/string'

Class.send(:prepend, MiniActiveSupport::Class)
Module.send(:prepend, MiniActiveSupport::Module)
String.send(:prepend, MiniActiveSupport::String)

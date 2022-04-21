# frozen_string_literal: true

require_relative 'mini_active_support/array'
require_relative 'mini_active_support/class'
require_relative 'mini_active_support/date_time'
require_relative 'mini_active_support/false_class'
require_relative 'mini_active_support/hash'
require_relative 'mini_active_support/hash_with_indifferent_access'
require_relative 'mini_active_support/module'
require_relative 'mini_active_support/nil_class'
require_relative 'mini_active_support/numeric'
require_relative 'mini_active_support/proc'
require_relative 'mini_active_support/string'
require_relative 'mini_active_support/true_class'

Array.send(:prepend, MiniActiveSupport::Array)
Class.send(:prepend, MiniActiveSupport::Class)
DateTime.send(:prepend, MiniActiveSupport::DateTime)
FalseClass.send(:prepend, MiniActiveSupport::FalseClass)
Hash.send(:prepend, MiniActiveSupport::Hash)
Module.send(:prepend, MiniActiveSupport::Module)
NilClass.send(:prepend, MiniActiveSupport::NilClass)
Numeric.send(:prepend, MiniActiveSupport::Numeric)
Proc.send(:prepend, MiniActiveSupport::Proc)
String.send(:prepend, MiniActiveSupport::String)
TrueClass.send(:prepend, MiniActiveSupport::TrueClass)

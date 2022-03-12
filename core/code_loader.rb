# frozen_string_literal: true

# Base. Code loading layer. START
class CodeLoader
  def initialize
    @typestamp = File.mtime(__FILE__)
  end

  def check_updates!
    return false if @typestamp == File.mtime(__FILE__)

    self.class.reload!
    @typestamp = File.mtime(__FILE__)
    true
  end

  def self.reload!
    puts 'Код был изменен'
    load(__FILE__)
  end
end

def reload!
  CodeLoader.reload!
end
# Base. Code loading layer. END

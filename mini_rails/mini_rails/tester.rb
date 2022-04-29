# frozen_string_literal: true

module MiniRails
  class Tester
    # @param argv [Array<String>]
    def call(argv)
      # 0: Set test env
      ENV['RACK_ENV'] = 'test'
      ENV['MINI_RAILS_ENV'] = 'test'

      # 1: Clean database
      ::MiniActiveRecord::Base.driver.destroy_database!

      # 2: Require all factories
      factories = Dir[MiniRails.root.join("spec/factories/**/*.rb")]
      factories.each { |file_path| require file_path }

      # 3: Require each test file
      files = if argv.present?
        paths = argv.map do |str|
          str.end_with?('.rb') ? str : "#{str}**/*.rb"
        end
        paths.map do |path|
          Dir.glob(MiniRails.root.join(path))
        end.reduce(:+)
      else
        Dir.glob(MiniRails.root.join("spec/**/*_spec.rb"))
      end

      files.each do |file_path|
        full_path = MiniRails.root.join(file_path)
        unless File.exist?(full_path)
          puts "Warning file '#{full_path}' does not exist"
        end
        short_path = file_path.gsub(/^.*\/spec\//, '/spec/').gsub(/^spec\//, '/spec/')
        # puts "Running test cases for '#{short_path}'"
        require full_path
      end

      # 4: Run all tests
      ::MiniRSpec.run_tests

      # 5: Clean database
      ::MiniActiveRecord::Base.driver.destroy_database!
    end
  end
end

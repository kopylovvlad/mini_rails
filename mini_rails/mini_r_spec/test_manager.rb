# frozen_string_literal: true

module MiniRSpec
  class TestManager
    include ::Singleton

    attr_reader :info

    def initialize
      @info = {
        success: [],
        failure: []
      }
    end

    def add_success(context)
      @info[:success] << context
    end

    def add_failure(context, exception)
      @info[:failure] << [context, exception]
    end

    def reset_stat!
      @info[:success] = []
      @info[:failure] = []
      nil
    end

    def show_stat
      success = @info[:success].size
      failure = @info[:failure].size
      all = success + failure

      puts "Finished: #{all} examples, #{failure} failures"

      return if failure == 0

      puts "Failures:\n\r"

      @info[:failure].each_with_index do |arr, index|
        context, exc = arr
        trace = exc.backtrace.reject{ |i| i.include?('/mini_r_spec/') || i.include?('/mini_rails/')}

        code_line, _ = trace.first.split(':in ')
        file_path, string = code_line.split(':')
        line = File.open(file_path).to_a[string.to_i - 1].strip

        puts "  #{index+1}) #{context}".red
        puts "    Failure/Error: #{line}".red
        puts ''
        puts "    #{exc.class}:".red
        puts "      #{exc.message}".red
        trace.first(3).each do |str|
          puts "    # #{str}".red
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative "logger/levels"
require_relative "logger/version"
require_relative "logger/handlers/console"

module TTY
  class Logger
    include Levels

    # Error raised by this logger
    class Error < StandardError; end

    # The log handling device
    attr_reader :handler

    # Logging severity level
    attr_reader :level

    # By default output to stderr
    attr_reader :output

    def initialize(output: $stderr, level: :info, handler: Handlers::Console)
      @output = output
      @level = level
      @handler = handler.new(output: output)
    end

    # Check current level against another
    #
    # @return [Symbol]
    #
    # @api public
    def log?(other_level)
      compare_levels(level, other_level) != :gt
    end

    # Log a message given the severtiy level
    #
    # @api public
    def log(current_level, *msg)
      return unless log?(current_level)

      if msg.empty? && block_given?
        msg = [yield]
      end
      @handler.(*msg)
    end

    # Log a message at :debug level
    #
    # @api public
    def debug(*msg, &block)
      log(:debug, *msg, &block)
    end

    # Log a message at :info level
    #
    # @api public
    def info(*msg, &block)
      log(:info, *msg, &block)
    end

    # Log a message at :warn level
    #
    # @api public
    def warn(*msg, &block)
      log(:warn, *msg, &block)
    end

    # Log a message at :error level
    #
    # @api public
    def error(*msg)
      log(:error, *msg, &block)
    end

    # Log a message at :fatal level
    #
    # @api public
    def fatal(*msg)
      log(:fatal, *msg, &block)
    end
  end # Logger
end # TTY

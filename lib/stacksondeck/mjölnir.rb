require 'thor'
require 'slog'


module StacksOnDeck

  # Thor's hammer! Like Thor with better logging
  class Mjölnir < Thor

    # Common options (for logging)
    COMMON_OPTIONS = {
      log: {
        type: :string,
        aliases: %w[ -l ],
        desc: 'Log to file instead of STDOUT',
        default: nil
      },
      debug: {
        type: :boolean,
        aliases: %w[ -d ],
        desc: 'Enable DEBUG-level logging',
        default: false
      },
      trace: {
        type: :boolean,
        aliases: %w[ -t ],
        desc: 'Enable TRACE-level logging',
        default: false
      }
    }

    # Decorator for Thor commands
    def self.include_common_options
      COMMON_OPTIONS.each do |name, spec|
        option name, spec
      end
    end


    no_commands do

      # Construct a Logger given the command-line options
      def log
        return @logger if defined? @logger
        level = :info
        level = :debug if options.debug?
        level = :trace if options.trace?
        colorize, prettify = false, false
        colorize, prettify = true, true if options.log.nil?
        device = options.log || $stdout
        @logger = Slog.new \
          out: device,
          level: level,
          colorize: colorize,
          prettify: prettify
      end

    end
  end
end
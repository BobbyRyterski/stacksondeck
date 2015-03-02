require 'slog'
require 'thor'


module StacksOnDeck

  # Thor's hammer! Like Thor with better logging
  class Mjolnir < Thor

    # Common options for Thor commands
    COMMON_OPTIONS = {
      log: {
        type: :string,
        aliases: %w[ -l ],
        desc: 'Log to file instead of STDOUT',
        default: ENV['SOD_LOG'] || nil
      },
      debug: {
        type: :boolean,
        aliases: %w[ -v ],
        desc: 'Enable DEBUG-level logging',
        default: ENV['SOD_DEBUG'] || false
      },
      trace: {
        type: :boolean,
        aliases: %w[ -z ],
        desc: 'Enable TRACE-level logging',
        default: ENV['SOD_TRACE'] || false
      }
    }

    # Decorate Thor commands with the options above
    def self.include_common_options
      COMMON_OPTIONS.each do |name, spec|
        option name, spec
      end
    end


    no_commands do

      # Return a connection to the given OpenStack service
      def os service
        @os ||= {}
        return @os[service] if @os.has_key? service
        @os[service] = OpenStack::Connection.create \
          auth_url: options.auth_url,
          auth_method: options.auth_method,
          authtenant_id: options.auth_tenant,
          username: options.auth_user,
          api_key: options.auth_pass,
          service_type: service
        log.trace \
          event: 'OpenStack connection',
          service: service
        return @os[service]
      end


      # Construct a Logger given the command-line options
      def log
        return @logger if defined? @logger
        level = :info
        level = :debug if options.debug?
        level = :trace if options.trace?
        device = options.log || $stderr
        pretty = device.tty? rescue false
        @logger = Slog.new \
          out: device,
          level: level,
          colorize: pretty,
          prettify: pretty
      end

    end
  end
end
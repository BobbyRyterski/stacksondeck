require 'thor'
require 'slog'
require 'openstack'


module StacksOnDeck

  # Thor's hammer! Like Thor with better logging
  class Mjölnir < Thor

    # Common options for Thor commands
    COMMON_OPTIONS = {
      log: {
        type: :string,
        aliases: %w[ -l ],
        desc: 'Log to file instead of STDOUT',
        default: ENV['SOD_LOG'] || nil
      },
      color: {
        type: :boolean,
        aliases: %w[ -c ],
        desc: 'Colorize log events by level',
        default: ENV['SOD_COLOR'] || true
      },
      pretty: {
        type: :boolean,
        aliases: %w[ -c ],
        desc: 'Use pretty JSON for log events',
        default: ENV['SOD_PRETTY'] || true
      },
      debug: {
        type: :boolean,
        aliases: %w[ -d ],
        desc: 'Enable DEBUG-level logging',
        default: ENV['SOD_DEBUG'] || false
      },
      trace: {
        type: :boolean,
        aliases: %w[ -z ],
        desc: 'Enable TRACE-level logging',
        default: ENV['SOD_TRACE'] || false
      },
      auth_url: {
        type: :boolean,
        aliases: %w[ -u ],
        desc: 'OpenStack authorization URL',
        default: ENV['OS_AUTH_URL']
      },
      auth_method: {
        type: :string,
        aliases: %w[ -m ],
        desc: 'OpenStack authorization method',
        default: ENV['OS_AUTH_METHOD'] || 'password'
      },
      auth_tenant: {
        type: :string,
        aliases: %w[ -t ],
        desc: 'OpenStack authorization tenant ID',
        default: ENV['OS_TENANT_ID']
      },
      auth_user: {
        type: :string,
        aliases: %w[ -u ],
        desc: 'OpenStack authorization username',
        default: ENV['OS_USERNAME']
      },
      auth_pass: {
        type: :string,
        aliases: %w[ -p ],
        desc: 'OpenStack autorization password',
        default: ENV['OS_PASSWORD']
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
        @logger = Slog.new \
          out: device,
          level: level,
          colorize: options.color?,
          prettify: options.pretty?
      end

    end
  end
end
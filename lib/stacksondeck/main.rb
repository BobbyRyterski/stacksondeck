require 'logger'
require 'rack'

require_relative 'app'
require_relative 'mjolnir'
require_relative 'metadata'


Thread.abort_on_exception = true

module StacksOnDeck

  # StacksOnDeck's entrypoint.
  class Main < Mjolnir


    desc 'version', 'Echo the application version'
    def version
      puts VERSION
    end


    desc 'art', 'View the application art'
    def art
      puts "\n%s\n" % ART
    end

    SYSTEM_KNIFE = '/etc/chef/knife.rb'
    USER_KNIFE   = File.join(ENV['HOME'] || '', '.chef', 'knife.rb')

    DEFAULT_KNIFE = if File.exist? SYSTEM_KNIFE
      SYSTEM_KNIFE
    elsif File.exist? USER_KNIFE
      USER_KNIFE
    end

    desc 'server', 'Start application web server'
    option :bind, \
      type: :string,
      aliases: %w[ -b ],
      desc: 'Set Sinatra interface',
      default: '0.0.0.0'
    option :port, \
      type: :numeric,
      aliases: %w[ -p ],
      desc: 'Set Sinatra port',
      default: 4567
    option :environment, \
      type: :string,
      aliases: %w[ -e ],
      desc: 'Set Sinatra environment',
      default: 'development'
    option :config, \
      type: :string,
      aliases: %w[ -c ],
      desc: 'Location of Chef configuration',
      default: DEFAULT_KNIFE,
      required: DEFAULT_KNIFE.nil?
    option :username, \
      type: :string,
      aliases: %w[ -u ],
      desc: 'Username value for Rundeck node',
      default: '${job.username}'
    option :refresh, \
      type: :numeric,
      aliases: %w[ -r ],
      desc: 'Refresh interval in seconds',
      default: 900
    option :hints, \
      type: :string,
      aliases: %w[ -h ],
      desc: 'JSON file with node hints',
      required: false
    include_common_options
    def server
      App.set :log, log
      App.set :bind, options.bind
      App.set :port, options.port
      App.set :config, options.config
      App.set :refresh, options.refresh
      App.set :username, options.username
      App.set :environment, options.environment
      App.set :hints, options.hints

      if options.debug?
        App.set :raise_errors, true
        App.set :dump_errors, true
        App.set :show_exceptions, true
        App.set :logging, ::Logger::DEBUG
      end

      Celluloid.logger = options.trace? ? log : nil

      log.info event: 'server', options: options
      App.run!
    end

  end
end
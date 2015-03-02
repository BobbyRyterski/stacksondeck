require 'logger'
require 'rack'

require_relative 'app'
require_relative 'mjolnir'
require_relative 'metadata'


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
      default: '/etc/chef/knife.rb'
    option :database, \
      type: :string,
      aliases: %w[ -d ],
      desc: 'Location of state database',
      default: '/etc/sod.db'
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
    include_common_options
    def server
      App.set :log, log
      App.set :bind, options.bind
      App.set :port, options.port
      App.set :config, options.config
      App.set :refresh, options.refresh
      App.set :database, options.database
      App.set :username, options.username
      App.set :environment, options.environment

      if options.debug?
        App.set :raise_errors, true
        App.set :dump_errors, true
        App.set :show_exceptions, true
        App.set :logging, ::Logger::DEBUG
      end

      Celluloid.logger = nil
      Thread.abort_on_exception = false

      if options.trace?
        Celluloid.logger = log
        Thread.abort_on_exception = true
      end

      log.debug event: 'server starting', options: options
      App.run!
    end

  end
end
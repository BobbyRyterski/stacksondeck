require 'json'

require 'thor'
require 'thor/util'
require 'thor/actions'

require_relative 'mjölnir'
require_relative 'helpers'
require_relative 'commands'
require_relative 'metadata'


module StacksOnDeck

  # StacksOnDeck's entrypoint.
  class Main < Mjölnir
    include StacksOnDeck::Helpers
    include StacksOnDeck::Commands


    desc 'version', 'Echo the application version'
    def version
      puts VERSION
    end


    desc 'art', 'View the application art'
    def art
      puts "\n%s\n" % ART
    end


    desc 'servers', 'List OpenStack compute (Nova) instances'
    include_common_options
    def servers
      compute = os 'compute'
      servers = compute.servers.map do |s|
        compute.server(s[:id]).to_hash
      end
      log.info command: 'servers', servers: servers
    end


    desc 'server INSTANCE_ID', 'Show an OpenStack compute (Nova) instance'
    include_common_options
    def server instance_id
      compute = os 'compute'
      server  = compute.server(instance_id).to_hash
      log.info command: 'server', server: server
    end


  end
end
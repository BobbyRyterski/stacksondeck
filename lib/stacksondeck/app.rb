require 'pathname'
require 'thread'
require 'json'
require 'yaml'

require 'ridley'
require 'daybreak'
require 'sinatra/base'

require_relative 'metadata'


module StacksOnDeck
  class App < Sinatra::Application

    def self.run!
      at_exit { close! }
      open!

      Thread.new do
        loop do
          refresh!
          sleep settings.refresh
        end
      end

      super
    end


    get '/' do
      content_type :yaml
      last_modified @@last_modified
      @@db_dump
    end

    get '/v' do
      content_type :text
      VERSION
    end


  private


    def self.log ; settings.log end

    def log ; settings.log end


    def self.db_copy
      @@db.lock do
        @@db.inject({}) { |h,(k,v)| h[k] = v ; h }
      end
    end


    def self.open!
      log.info event: 'open!', db: settings.database
      @@db = Daybreak::DB.new settings.database
      @@db_dump = YAML.dump db_copy
      @@last_modified = Time.now
      @@ridley = Ridley.from_chef_config settings.config
    end


    def self.close!
      log.info event: 'close!', db: settings.database
      @@db.flush
      @@db.close
    end


    def self.refresh!
      started = Time.now

      nodes = @@ridley.partial_search :node, 'name:*', %w[
        name
        hostname
        fqdn
        roles
        chef_environment
        tags
        kernel.machine
        platform_version
        platform_family
        platform
      ]

      node_resources = {}

      nodes.each do |n|
        name = n.name
        n = n.automatic

        username  = settings.username
        remoteUrl = File.join @@ridley.server_url, 'nodes', name
        editUrl   = File.join remoteUrl, 'edit'

        tags  = n.tags  || []
        tags += n.roles || []
        tags << n.chef_environment
        tags.compact!

        next if n.hostname.nil?

        node_resources[name] = {
          'hostname' => n.hostname,
          'description' => n.fqdn,
          'osArch' => n.kernel.machine,
          'osVersion' => n.platform_version,
          'osFamily' => n.platform_family,
          'osName' => n.platform,
          'username' => username,
          'remoteUrl' => remoteUrl,
          'editUrl' => editUrl,
          'tags' => tags.join(',')
        }
      end

      @@db.lock do
        @@db.clear
        @@db.update! node_resources
      end

      @@db_dump = YAML.dump node_resources

      @@last_modified = Time.now

      log.info event: 'refreshed!', elapsed: (Time.now - started)

      return node_resources
    end


  end
end
require 'pathname'
require 'thread'
require 'json'
require 'yaml'

require 'ridley'
require 'sinatra/base'

require_relative 'metadata'


module StacksOnDeck
  class App < Sinatra::Application

    def self.run!
      log.info event: 'run!'

      @@db = {}
      @@db_dump = ''
      @@last_modified = Time.now
      @@ridley = Ridley.from_chef_config settings.config

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
      if params['username']
        override_db = @@db.inject({}) do |h,(k,v)|
          v['username'] = params['username']
          h[k] = v ; h
        end
        YAML.dump override_db
      else
        @@db_dump
      end
    end

    get '/v' do
      content_type :text
      VERSION
    end



  private

    def self.log ; settings.log end

    def log ; settings.log end


    def self.refresh_tagfile!
      return {} if settings.tagfile.nil?
      JSON.parse File.read(settings.tagfile)
    end

    def self.refresh!
      log.info event: 'refresh!'
      started = Time.now

      node_tags = refresh_tagfile!

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
      ], rows: 1_000_000 # A million hosts oughta be enough for anyone!

      @@db = {}

      nodes.each do |n|
        name = n.name
        n = n.automatic

        username  = settings.username
        remoteUrl = File.join @@ridley.server_url, 'nodes', name
        editUrl   = File.join remoteUrl, 'edit'

        tags  = n.tags  || []
        tags += n.roles || []
        tags << n.chef_environment
        tags += node_tags[name] if node_tags.include? name
        tags  = tags.uniq.compact

        next if n.hostname.nil?

        @@db[name] = {
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

      @@db_dump = YAML.dump @@db

      @@last_modified = Time.now

      log.info event: 'refreshed', elapsed: (Time.now - started)

      return @@db
    end


  end
end
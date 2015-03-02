require 'pathname'
require 'thread'
require 'json'
require 'yaml'

require 'ridley'
require 'daybreak'
require 'sinatra/base'



module StacksOnDeck
  class App < Sinatra::Application

    def self.run!
      open!
      at_exit { close! }
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
      @@db_dump
    end



  private


    def self.log ; settings.log end

    def log ; settings.log end


    def self.db_copy
      @@db.lock do
        @@db.map { |_,v| v }
      end
    end


    def self.open!
      reopen!
      log.debug event: 'open!', db: settings.database
      @@db_dump = YAML.dump db_copy
    end


    def self.reopen!
      old_db = @@db if defined? @@db
      @@db = Daybreak::DB.new settings.database
      old_db.close if old_db
    end


    def self.close!
      log.debug event: 'close!', db: settings.database
      @@db.close
    end


    def self.refresh!
      log.debug event: 'refresh!', config: settings.config

      started = Time.now

      ridley = Ridley.from_chef_config settings.config

      chef_server_url = ridley.server_url

      nodes = ridley.partial_search :node, 'name:*', %w[
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
        username = settings.username
        remoteUrl = File.join chef_server_url, 'nodes', name
        editUrl = File.join remoteUrl, 'edit'

        tags  = n.tags  || []
        tags += n.roles || []
        tags << n.chef_environment
        tags.compact!

        node_resources[name] = {
          'nodename' => name,
          'hostname' => n.hostname,
          'description' => n.fqdn,
          'osArch' => n.kernel.machine,
          'osVersion' => n.platform_version,
          'osFamily' => n.platform_family,
          'osName' => n.platform,
          'username' => username,
          'remoteUrl' => remoteUrl,
          'editUrl' => editUrl,
          'tags' => tags
        }
      end

      @@db.lock do
        @@db.clear
        @@db.update! node_resources
      end

      reopen!

      @@db_dump = YAML.dump node_resources.values

      log.debug event: 'refreshed!', elapsed: (Time.now - started)

      return node_resources


    rescue Celluloid::Task::TerminatedError
      # nop
    end


  end
end
require 'thor'
require 'thor/util'
require 'thor/actions'

require_relative 'mjölnir'
require_relative 'commands'
require_relative 'metadata'


module StacksOnDeck

  # StacksOnDeck's entrypoint.
  class Main < Mjölnir
    include StacksOnDeck::Commands


    desc 'version', 'Echo the application version'
    def version
      puts VERSION
    end


    desc 'art', 'View the application art'
    def art
      puts "\n%s\n" % ART
    end


    desc 'snapshot', 'Stop, snapshot, and restart an instance'
    include_common_options
    option :instance_id, \
      type: :string,
      aliases: %w[ -i ],
      desc: 'Specify an instance ID'
    option :instance_name, \
      type: :string,
      aliases: %w[ -n ],
      desc: 'Specify an instance name'
    def snapshot
      if options.instance_id and options.instance_name
        error "Provide a value for either '--instance-id' or '--instance-name' (not both)"
        exit 1
      end

      unless options.instance_id or options.instance_name
        error "No value provided for either '--instance-id' or '--instance-name'"
        exit 1
      end

      instance = find_instance options.instance_id, options.instance_name
      snapshot_instance instance
    end

  end
end
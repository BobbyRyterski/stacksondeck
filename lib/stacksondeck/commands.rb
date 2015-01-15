require_relative 'commands/snapshot'


module StacksOnDeck

  # Command-related mixin for StacksOnDeck's Main class
  module Commands

    def find_instance_by_id id
      raise 'Could not find instance with the given INSTANCE_ID'
    end

  end
end
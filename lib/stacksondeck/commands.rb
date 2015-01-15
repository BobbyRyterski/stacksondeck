require_relative 'commands/snapshot'


module StacksOnDeck

  # Command-related mixin for StacksOnDeck's Main class
  module Commands


    def find_instance id, name
      find_instance_by_id id if id
      find_instance_by_name name if name
    end


    def find_instance_by_id id
      raise 'Could not find instance with the given INSTANCE_ID'
    end


    def find_instance_by_name name
      raise 'Could not find instance with the given INSTANCE_NAME'
    end


  end
end
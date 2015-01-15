require 'thor'
require 'slog'

require_relative 'helpers'
require_relative 'metadata'


module StacksOnDeck

  # StacksOnDeck's entrypoint.
  class Main < Thor
    include StacksOnDeck::Helpers


    desc 'version', 'Echo the application version'
    def version
      puts VERSION
    end


    desc 'art', 'View the application art'
    def art
      puts "\n%s\n" % ART
    end

  end
end
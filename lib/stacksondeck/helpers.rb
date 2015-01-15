require 'thor/util'
require 'thor/actions'


module StacksOnDeck

  # Mixins for StacksOnDeck's Thor subclasses.
  module Helpers

    # Save the canonical implementation of "puts"
    alias_method :old_puts, :puts

    # Monkeypatch puts to support Thor::Shell::Color.
    def puts *args
      return old_puts if args.empty?
      old_puts shell.set_color(*args)
    end


    # Shortcut for Thor::Util.
    def util ; Thor::Util end


    # Shortcut for Thor::Actions.
    def actions ; Thor::Actions end

  end
end
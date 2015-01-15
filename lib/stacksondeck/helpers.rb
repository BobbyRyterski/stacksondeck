require 'hashie'


module OpenStack
  module Extensions
    module ToHash
      def to_hash
        ivars = instance_variables.reject do |ivar|
          ivar =~ /^@svrmgmt/ or ivar == :@compute
        end

        ivars.inject({}) do |h, key|
          val = instance_variable_get key
          val = val.to_hash if val.respond_to? :to_hash
          val = val.map { |i| i.to_hash if i.respond_to? :to_hash } if val.is_a? Array
          h[key.to_s.delete('@')] = val ; h
        end
      end
    end
  end

  module Compute
    class Address
      include OpenStack::Extensions::ToHash
    end
    class Server
      include OpenStack::Extensions::ToHash
    end
    class Metadata
      include OpenStack::Extensions::ToHash
    end
  end
end


module StacksOnDeck
  module Helpers

    class PromiscuousHash < Hash
      include Hashie::Extensions::DeepMerge
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::IndifferentAccess

      def initialize other_hash={}
        self.deep_merge! other_hash
      end
    end

  end
end
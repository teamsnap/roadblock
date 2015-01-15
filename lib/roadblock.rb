require_relative "roadblock/authorizer"
require_relative "roadblock/stack"
require_relative "roadblock/version"

module Roadblock
  # Include Roadblock.authorizer into a class to make it an authorizer.
  def self.authorizer
    Module.new do
      def self.included(descendant)
        descendant.send(:include, ::Roadblock::Authorizer)
      end
    end
  end
end

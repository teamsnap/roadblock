require_relative "roadblock/authorizer"
require_relative "roadblock/version"

module Roadblock
  def self.authorizer
    Module.new do
      def self.included(descendant)
        descendant.send(:include, ::Roadblock::Authorizer)
      end
    end
  end
end

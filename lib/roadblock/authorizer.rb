module Roadblock
  module Authorizer
    # Creates an authorizer for the given object and any provided scopes.
    #
    # @param auth_object [Object] the object (usually a user) to authorize for.
    # @param scopes [Array<Symbol>] the scopes (if any) associated with the
    #   auth_object.
    #
    # @return [self]
    def initialize(auth_object, scopes: [])
      self.auth_object = auth_object
      self.scopes = scopes
    end

    # Returns whether the current auth_object can perform the given action on
    # the provided object.
    #
    # @param action [Symbol] the action to check. Most often :read or :write.
    # @param object [Object] the object to authorize against.
    #
    # @return [true, false]
    def can?(action, object)
      if block_given?
        yield(object)
      else
        objects = [*object]
        objects
          .map { |obj| send("can_#{action}?", obj) }
          .all?
      end
    end

    private

    attr_accessor :auth_object, :scopes
  end
end

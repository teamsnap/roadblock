module Roadblock
  module Authorizer
    def initialize(auth_object, scopes: [])
      self.auth_object = auth_object
      self.scopes = scopes
    end

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

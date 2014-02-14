module Roadblock
  module Authorizer
    def initialize(user, scopes: [])
      self.user = user
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

    attr_accessor :user, :scopes
  end
end

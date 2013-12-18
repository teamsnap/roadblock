module Roadblock
  module Authorizer
    def initialize(user, scopes: [])
      self.user = user
      self.scopes = scopes
    end

    def can?(action, objects)
      objects = [*objects]
      objects
      .map { |object| send("can_#{action}?", object) }
      .all?
    end

    private

    attr_accessor :user, :scopes
  end
end

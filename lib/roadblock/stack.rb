module Roadblock
  class Stack
    NULL_AUTHORIZER_PROC = lambda { |object| false }

    def initialize(auth_object, scopes: [])
      self.auth_object = auth_object
      self.scopes = scopes
      self.authorizers = []
    end

    def add(*auths)
      self.authorizers = authorizers + auths
    end

    def can?(action, objects)
      objects = [*objects]

      stack = authorizers.reverse.inject(NULL_AUTHORIZER_PROC) do |authorizer_proc, authorizer_klass|
        lambda { |obj|
          authorizer = authorizer_klass.new(auth_object, scopes: scopes)

          authorizer.can?(action, obj) do |inner_obj|
            authorizer.send("can_#{action}?", inner_obj, &authorizer_proc)
          end
        }
      end

      objects
        .map { |object| stack.call(object) }
        .all?
    end

    def respond_to?(method)
      /can_(.*?)\?/.match(method) ? true : false
    end

    def method_missing(method, *args)
      match = /can_(.*?)\?/.match(method)

      if match
        can?(match[1], *args)
      else
        super
      end
    end

    private

    attr_accessor :auth_object, :scopes, :authorizers
  end
end

module Roadblock
  class Stack
    NULL_AUTHORIZER_PROC = lambda { |object| false }

    # The Stack allows you to create middleware layers of authorizer to reduce
    # duplication, escape early, etc.
    #
    # @param auth_object [Object] the object to authorize for. Usually a user.
    # @param scopes [Array<Symbol>] the scopes (if any) associated with the
    #   auth_object.
    #
    # @return [self]
    def initialize(auth_object, scopes: [])
      self.auth_object = auth_object
      self.scopes = scopes
      self.authorizers = []
    end

    # Adds one or more authorizers to the Stack.
    #
    # @param *auths [Authorizer] the authorizer(s) to add to the Stack.
    #
    # @return [Array<Authorizer>] the current stack.
    def add(*auths)
      self.authorizers = authorizers + auths
    end

    # Checks if the given action can be performed on all the objects.
    #
    # @param action [Symbol] the action the authorize for.
    # @param objects [Array<Object>] the objects to authorize against.
    #
    # @return [true, false]
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

require_relative "spec_helper"
require_relative "../lib/roadblock"

class TestAuthorizer
  include Roadblock.authorizer

  def can_peek?(object)
    scopes.include?("peekable") &&
      auth_object == object
  end

  def can_wink?(object)
    auth_object == object
  end
end

class ForwardingAuthorizer
  include Roadblock.authorizer

  def can_peek?(object)
    yield(object)
  end
end

class ReturningMiddleware
  include Roadblock.authorizer

  def can_peek?(object)
    false
  end
end

describe Roadblock::Authorizer do
  subject { TestAuthorizer }

  describe "#can?" do
    it "correctly forwards call" do
      user = double
      scopes = ["peekable"]
      auth = subject.new(user, :scopes => scopes)

      expect(auth.can?(:peek, user)).to be true
    end

    it "accepts multiple objects" do
      user = double
      scopes = ["peekable"]
      auth = subject.new(user, :scopes => scopes)

      expect(auth.can?(:peek, [user, user])).to be true
    end

    it "requires all objects to pass authorization" do
      user = double
      scopes = ["peekable"]
      auth = subject.new(user, :scopes => scopes)

      expect(auth.can?(:peek, [user, nil])).to eq(false)
    end

    it "doesn't require scopes to be used" do
      user = double
      auth = subject.new(user)

      expect(auth.can?(:wink, user)).to be(true)
    end
  end
end

describe Roadblock::Stack do
  describe "#can?" do
    it "correctly forwards call" do
      user = double
      scopes = ["peekable"]

      stack = Roadblock::Stack.new(user, :scopes => scopes)
      stack.add(TestAuthorizer)

      expect(stack.can?(:peek, user)).to be(true)
    end

    it "correctly forwards call with alternate call style" do
      user = double
      scopes = ["peekable"]

      stack = Roadblock::Stack.new(user, :scopes => scopes)
      stack.add(TestAuthorizer)

      expect(stack.can_peek?(user)).to be(true)
    end

    it "correctly forwards call through middleware" do
      user = double
      scopes = ["peekable"]

      stack = Roadblock::Stack.new(user, :scopes => scopes)
      stack.add(ForwardingAuthorizer)
      stack.add(TestAuthorizer)

      expect(stack.can?(:peek, user)).to be(true)
    end

    it "correctly handles middleware returning early" do
      user = double
      scopes = ["peekable"]

      stack = Roadblock::Stack.new(user, :scopes => scopes)
      stack.add(ReturningMiddleware)
      stack.add(TestAuthorizer)

      expect(stack.can?(:peek, user)).to be(false)
    end

    it "accepts multiple objects" do
      user = double
      scopes = ["peekable"]

      stack = Roadblock::Stack.new(user, :scopes => scopes)
      stack.add(TestAuthorizer)

      expect(stack.can?(:peek, [user, user])).to be true
    end

    it "accepts multiple objects with alternate call style" do
      user = double
      scopes = ["peekable"]

      stack = Roadblock::Stack.new(user, :scopes => scopes)
      stack.add(TestAuthorizer)

      expect(stack.can_peek?([user, user])).to be true
    end

    it "requires all objects to pass authorization" do
      user = double
      scopes = ["peekable"]

      stack = Roadblock::Stack.new(user, :scopes => scopes)
      stack.add(TestAuthorizer)

      expect(stack.can?(:peek, [user, nil])).to eq(false)
    end

    it "doesn't require scopes to be used" do
      user = double

      stack = Roadblock::Stack.new(user)
      stack.add(TestAuthorizer)

      expect(stack.can?(:wink, user)).to be(true)
    end
  end
end

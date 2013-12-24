require_relative "spec_helper"
require_relative "../lib/roadblock"

class TestAuthorizer
  include Roadblock.authorizer

  def can_peek?(object)
    scopes.include?("peekable") &&
      user == object
  end

  def can_wink?(object)
    user == object
  end
end

describe Roadblock do
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

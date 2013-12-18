# Roadblock

A simple authorization library.

## Installation

Add this line to your application's Gemfile:

    gem 'roadblock'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roadblock

## Usage

    require "roadblock"

    class TeamAuthorizer
      include Roadblock.authorizer

      def can_read?(team)
        scopes.include?("read") &&
          user.teams.include?(team)
      end

      def can_write?(team)
        scopes.include?("write_teams") && (
          user.managed_teams.include?(team) ||
          user.owned_teams.include?(team)
        )
      end
    end

    scopes = ["read", "write_teams"] # Optional oauth scopes
    auth = TeamAuthorizer.new(current_user, :scopes => scopes)
    team = Team.find(params[:id])

    auth.can?(:read, team)
    auth.can?(:write, team)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

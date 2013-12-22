# Roadblock

[![Gem Version](https://badge.fury.io/rb/roadblock.png)](http://badge.fury.io/rb/roadblock)
[![Semaphore](https://semaphoreapp.com/api/v1/projects/f1ccf0c3ff7565f975caef0fdfcf649f24f033fb/118939/shields_badge.png)](https://semaphoreapp.com/minter/roadblock)
[![Code Climate](https://codeclimate.com/github/teamsnap/roadblock.png)](https://codeclimate.com/github/teamsnap/roadblock)
[![Coverage Status](https://coveralls.io/repos/teamsnap/roadblock/badge.png?branch=master)](https://coveralls.io/r/teamsnap/roadblock?branch=master)
[![Dependency Status](https://gemnasium.com/teamsnap/roadblock.png)](https://gemnasium.com/teamsnap/roadblock)
[![License](http://img.shields.io/license/MIT.png?color=green)](http://opensource.org/licenses/MIT)

A simple authorization library.

![Roadblock](http://i.imgur.com/RzJlc7D.jpg)

Roadblock provides a simple interface for checking if a ruby object has the authority to interact with another object. The most obvious example being if the current user in your rails controller can read/write the object they're attempting to access.

Nearly all authorization libraries require heavy weight configuration and tight integration with Rails. This library was created to provide the simplest solution to the problem without requiring any external dependencies. It doesn't require Rails or any of it's subcomponents and weighs in at less than 10 LOC for the actual implementation. The library also optionally understands OAUTH scopes, something other authorization libraries do not.

## Installation

Add this line to your application's Gemfile:

    gem 'roadblock'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roadblock

## Usage

```ruby
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

auth.can?(:read, team) # or auth.can_read?(team)
auth.can?(:write, team) # or auth.can_write?(team)

# When using the #can? syntax, you can pass in an enumerable
# #can? will then tell you if the user is able to perform the
# action on all of the objects. `true` they can, `false` they
# cannot.

teams = Team.where(:sport => :hockey)

auth.can?(:read, teams)
auth.can?(:write, teams)
```
    
## Roadmap

- Add optional faliure messages

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

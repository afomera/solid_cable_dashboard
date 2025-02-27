# Solid Cable Dashboard

A beautiful dashboard for [solid_cable](https://github.com/rails/solid_cable). Monitor your Rails application WebSocket performance with detailed stats and visualizations.

## Features

- Real-time monitoring of broadcasted messages and channel subscriptions
- Visual charts to track WebSocket activity over time
- Detailed views of all messages with size information
- Ability to inspect and delete individual messages
- Dark mode support
- Responsive design for all device sizes

## Installation

Add this line to your application's Gemfile:

```ruby
gem "solid_cable_dashboard"
```

And then execute:

```bash
$ bundle install
```

Run the installation generator:

```bash
$ rails generate solid_cable_dashboard:install
$ rails db:migrate
```

This will create a migration for the events table that tracks broadcasts, receives, subscribes, and unsubscribes.

## Usage

Mount the dashboard in your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount SolidCableDashboard::Engine => "/solid-cable"

  # The rest of your routes...
end
```

Now you can access the dashboard at `/solid-cable`.

## Configuration

You can configure the dashboard by creating an initializer:

```ruby
# config/initializers/solid_cable_dashboard.rb
SolidCableDashboard.configure do |config|
  config.title = "My App WebSocket Dashboard"
end
```

## Authentication

For authentication, you can use routing constraints:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  authenticate :user, -> (user) { user.admin? } do
    mount SolidCableDashboard::Engine => "/solid-cable"
  end
end
```

Or you can create a controller concern:

```ruby
# app/controllers/concerns/solid_cable_dashboard/authentication.rb
module SolidCableDashboard
  module Authentication
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_solid_cable_dashboard
    end

    private

    def authenticate_solid_cable_dashboard
      if !user_signed_in? || !current_user.admin?
        redirect_to main_app.root_path, alert: "Not authorized"
      end
    end
  end
end
```

Then require it in an initializer:

```ruby
# config/initializers/solid_cable_dashboard.rb
Rails.application.config.to_prepare do
  SolidCableDashboard::ApplicationController.include SolidCableDashboard::Authentication
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/afomera/solid_cable_dashboard.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

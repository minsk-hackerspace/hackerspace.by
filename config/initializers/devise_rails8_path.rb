require 'devise'
Devise # make sure it's already loaded

module Devise
  def self.mappings
    # Starting from Rails 8.0, routes are lazy-loaded by default in test and development environments.
    # However, Devise's mappings are built during the routes loading phase.
    # To ensure it works correctly, we need to load the routes first before accessing @@mappings.
    Rails.application.try(:reload_routes_unless_loaded)
    @@mappings
  end
end

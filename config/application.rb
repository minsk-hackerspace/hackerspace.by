require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hspace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.autoload_lib(
      ignore: %w[
        bp_create.rb
        belinvestbank_api/bib_parse.rb
        belinvestbank_api/bib_test.rb
      ]
    )

    config.time_zone = 'Minsk'
    config.i18n.default_locale = :ru
    config.i18n.fallbacks = true
  end

  OPENED = 'opened'
  CLOSED = 'closed'
  UNKNOWN = 'unknown'
end

require_relative 'boot'

require 'rails/all'
require_relative '../lib/set_action_mailer_host'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Super
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.et_atos_api = ::Rails::Application::Configuration::Custom.new
    config.middleware.insert_before Rack::Sendfile, SetActionMailerHost

    insights_key = ENV.fetch('AZURE_APP_INSIGHTS_KEY', false)
    if insights_key
      config.azure_insights.enable = true
      config.azure_insights.key = insights_key
      config.azure_insights.role_name = ENV.fetch('AZURE_APP_INSIGHTS_ROLE_NAME', 'et-admin')
      config.azure_insights.role_instance = ENV.fetch('HOSTNAME', 'all')
      config.azure_insights.buffer_size = 500
      config.azure_insights.send_interval = 60
    else
      config.azure_insights.enable = false
    end

  end
end

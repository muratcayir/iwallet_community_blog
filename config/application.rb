require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CommunityBlog
  class Application < Rails::Application
    config.load_defaults 6.1
    config.active_support.cache_format_version = 7.0
    config.i18n.default_locale = :tr
    config.i18n.available_locales = %i[tr en]

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:3000', 'http://127.0.0.1:3000'
        resource '*',
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 credentials: true
      end
    end
  end
end

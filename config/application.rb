require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'securerandom'
require 'tempfile'
require 'csv'
require 'zip'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NterOne
  class Application < Rails::Application
    config.tld = `hostname`.match(/\w+$/).to_s

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'views', '*', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # config.assets.precompile += %w( brands.js general.js rules.js subjects.js )
    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths += %W(#{config.root}/app/workers)
    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths += %W(#{config.root}/app/policies/concerns)

    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      r301 %r{^/(.*)/$}, '/$1'
    end

    config.react.jsx_transform_options = {
      optional: ['es7.classProperties']
    }

    config.react.server_renderer_options = {
      files: ["server_rendering.js"], # files to load for prerendering
    }
  end
end

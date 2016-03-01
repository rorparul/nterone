NterOne::Application.configure do
  # config.after_initialize do
  #   Bullet.enable = true
  #   Bullet.alert = true
  #   Bullet.bullet_logger = true
  #   Bullet.console = true
  #   Bullet.growl = true
  #   Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
  #                   :password => 'bullets_password_for_jabber',
  #                   :receiver => 'your_account@jabber.org',
  #                   :show_online_status => true }
  #   Bullet.rails_logger = true
  #   Bullet.honeybadger = true
  #   Bullet.bugsnag = true
  #   Bullet.airbrake = true
  #   Bullet.rollbar = true
  #   Bullet.add_footer = true
  #   Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
  #   Bullet.stacktrace_excludes = [ 'their_gem', 'their_middleware' ]
  #   Bullet.slack = { webhook_url: 'http://some.slack.url', foo: 'bar' }
  # end
  # Settings specified here will take precedence over those in config/application.rb.
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  config.active_record.raise_in_transactional_callbacks = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => 'smtp.office365.com',
    :domain               => 'nterone.com',
    :port                 => 587,
    :user_name            => 'nci@nterone.com',
    :password             => 'Ni2015!!',
    :authentication       => :login,
    :enable_starttls_auto => true
  }
end

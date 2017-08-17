# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
# Rails.application.config.filter_parameters += [:password]
Rails.application.config.filter_parameters += [:password, :credit_card_number, :expiration_month, :expiration_year, :security_code]

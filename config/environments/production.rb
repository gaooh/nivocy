# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.logger = Logger.new(config.log_path, 'daily')

ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address => 'mail.drecom.co.jp',
    :port => 25,
    :domain => 'niboshi.drecom.jp'
  }
  
ActionMailer::Base.raise_delivery_errors = true

IM_SETTING = {
  :user        => "nivocy@im.drecom.co.jp", 
  :password    => "6Zx4UjtI", 
  :status      => "nivocy bot!"
}

DOMAIN = "niboshi.drecom.jp"

APP_CONFIG = {
  :domain => DOMAIN,
  :url => "http://#{DOMAIN}/",
  :service_name => "nivocy",
  :admin_email => "info@nivocy.drecom.jp"
}

GRUFF_CONFIG = {
  :ja_font => '/usr/share/fonts/truetype/sazanami/sazanami-gothic.ttf'
}

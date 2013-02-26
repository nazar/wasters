# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'desert'

Rails::Initializer.run do |config|
  config.plugins = [:community_engine, :white_list, :all]
  config.plugin_paths += ["#{RAILS_ROOT}/vendor/plugins/community_engine/plugins"]
  config.gem 'calendar_date_select', :version => '1.15'
  config.gem 'icalendar', :version => '1.1.3'
  config.gem 'authlogic', :version => '2.1.3'
  config.gem 'searchlogic', :version => '2.4.12'
  config.gem 'haml', :version => '2.2.21'
  config.gem 'htmlentities', :version => '4.2.0'
  config.gem 'ri_cal', :version => '0.8.5'
  config.gem 'desert', :version => '0.5.3'
  config.gem 'rails', :version => '2.3.4'

  config.action_controller.session = {
    :key    => '_wasters',
    :secret => 'kljfkjsdhjfiohoihjIOYOYGUBOLIJBYICIUGOI^&Y(YIOUHIOUH'
  }

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  # config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
    :address => "localhost",
    :port => 25,
    :domain => "panthersoftware.com",
  }
end

require "#{RAILS_ROOT}/vendor/plugins/community_engine/config/boot.rb"

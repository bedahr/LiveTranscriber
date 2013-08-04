require File.expand_path('../boot', __FILE__)

Booter.say "Loading Rails"
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module LiveTranscriber
  class Application < Rails::Application
    require 'extendable'
    require 'pp'
    require 'colored'
    require 'tempfile'

    # Loading core System
    Booter.say "Loading Extension System"
    load File.join(Rails.root, "lib/core/extension.rb")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.test_framework  :mini_test, fixture: false
      g.factory_girl dir: 'test/factories', suffix: 'factories'
    end

    require 'core/core_ext'
    require 'core/active_record_extensions'
    require 'core/helpers/form_builder'

    config.action_view.default_form_builder = Core::Helpers::FormBuilder

    ActiveRecord::Base.send :include, ActiveRecordExtensions

    WillPaginate.per_page = 100

  end
end

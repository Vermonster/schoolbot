require File.expand_path('../boot', __FILE__)

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_view/railtie"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Schoolbot
  class Application < Rails::Application
    config.i18n.default_locale = :api
    config.i18n.enforce_available_locales = true

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :delayed_job
  end
end

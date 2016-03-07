ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
abort("DATABASE_URL environment variable is set") if ENV["DATABASE_URL"]

require "rspec/rails"
require "shoulda/matchers"
require "email_spec"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

module Requests
  # Extend this module in spec/support/requests/*.rb
  include JSONRequests
  include ResponseJSON
end

module Features
  # Extend this module in spec/support/features/*.rb
  include APIMocking
  include DefaultLocale
  include Sessions
  include Subdomains
end

RSpec.configure do |config|
  config.include Requests, type: :request
  config.include Features, type: :feature
  config.include I18nHelper
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  config.before(:suite) do
    ENV['APPLICATION_HOST'] = "lvh.me:#{Capybara.current_session.server.port}"
  end
end

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :webkit
Capybara.default_driver = Capybara.javascript_driver

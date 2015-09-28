ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
abort("DATABASE_URL environment variable is set") if ENV["DATABASE_URL"]

require "rspec/rails"
require "shoulda/matchers"
require "capybara/poltergeist"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

module Requests
  # Extend this module in spec/support/requests/*.rb
  include JSONRequests
  include ResponseJSON
end

module Features
  # Extend this module in spec/support/features/*.rb
  include DefaultLocale
  include Sessions
  include Subdomains
end

RSpec.configure do |config|
  config.include Requests, type: :request
  config.include Features, type: :feature
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
end

ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :poltergeist

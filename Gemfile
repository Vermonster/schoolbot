source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "active_model_serializers", "~> 0.9.5"
gem "airbrake"
gem "auto_strip_attributes"
gem "aws-sdk"
gem "bcrypt"
gem "cb2"
gem "clockwork"
gem "delayed_job_active_record"
gem "email_validator"
gem "geocoder"
gem "intercom"
gem "newrelic_rpm"
gem "paperclip"
gem "pg"
gem "puma"
gem "rails", "4.2.7.1"
gem "recipient_interceptor"
gem "redis"
gem "responders"
gem "rest-client"

group :development do
  gem "letter_opener"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "scss_lint", require: false
end

group :test do
  gem "capybara-webkit"
  gem "database_cleaner"
  gem "email_spec"
  gem "launchy"
  gem "rspec-collection_matchers"
  gem "rspec-retry"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "test_after_commit"
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rails_stdout_logging"
  gem "rack-timeout"
end

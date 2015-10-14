source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "active_model_serializers"
gem "airbrake"
gem "auto_strip_attributes"
gem "aws-sdk", "~> 1.6" # TODO: Remove constraint once Paperclip supports 2.0
gem "bcrypt"
gem "cb2"
gem "clockwork"
gem "delayed-plugins-airbrake"
gem "delayed_job_active_record"
gem "email_validator"
gem "geocoder"
gem "paperclip"
gem "pg"
gem "puma"
gem "rails", "4.2.4"
gem "recipient_interceptor"
gem "redis"
gem "responders"
gem "rest-client"

group :development do
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "awesome_print"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "scss_lint", require: false
end

group :test do
  gem "database_cleaner"
  gem "launchy"
  gem "poltergeist"
  gem "rspec-collection_matchers"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rails_stdout_logging"
  gem "rack-timeout"
end

source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "active_model_serializers"
gem "airbrake"
gem "clockwork"
gem "delayed_job_active_record"
gem "devise"
gem "email_validator"
gem "geocoder"
gem "newrelic_rpm"
gem "pg"
gem "puma"
gem "rack-ssl-enforcer"
gem "rails", "4.2.3"
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
  gem "formulaic"
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

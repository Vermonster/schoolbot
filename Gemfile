source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "airbrake"
gem "delayed_job_active_record"
gem "email_validator"
gem "high_voltage"
gem "i18n-tasks"
gem "newrelic_rpm", ">= 3.9.8"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "4.2.1"
gem "recipient_interceptor"

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
  gem "rspec-rails", "~> 3.1.0"
  gem "rubocop", require: false
  gem "scss-lint", require: false
end

group :test do
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "poltergeist"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rails_stdout_logging"
  gem "rack-timeout"
end

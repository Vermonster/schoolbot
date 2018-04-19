Airbrake.configure do |config|
  config.project_id = ENV.fetch('AIRBRAKE_ID')
  config.project_key = ENV.fetch('AIRBRAKE_KEY')
  config.environment = Rails.env
  config.ignore_environments = %w[development test]
end

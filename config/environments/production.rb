require Rails.root.join("config/smtp")

Rails.application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true
  config.force_ssl = true
  config.log_level = :debug
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.static_cache_control = "public, max-age=#{1.year.to_i}"

  config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))
  config.action_controller.perform_caching = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS

  config.active_record.dump_schema_after_migration = false
  config.active_support.deprecation = :notify

  config.i18n.fallbacks = true

  config.log_formatter = ::Logger::Formatter.new

  config.middleware.use Rack::Deflater
end

Rack::Timeout.timeout = ENV.fetch("RACK_TIMEOUT", 10).to_i

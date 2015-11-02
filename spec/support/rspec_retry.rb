# Work around intermittent "unable to find input" failures on CI. Always seems
# to happen at least once (on random specs) on both Travis and Circle, but has
# never been seen locally.

if ENV['CI'].present?
  RSpec.configure do |config|
    config.default_retry_count = 3
    config.verbose_retry = true
    config.display_try_failure_messages = true
  end
end

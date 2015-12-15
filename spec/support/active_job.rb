RSpec.configure do |config|
  config.around(:each, perform_jobs: true) do |example|
    begin
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
      ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true
      example.run
    ensure
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = false
      ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = false
    end
  end
end

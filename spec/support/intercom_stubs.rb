RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /api\.intercom\.io/)
  end
end

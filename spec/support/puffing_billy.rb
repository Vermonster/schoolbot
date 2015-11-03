Billy.configure do |config|
  config.whitelist += [/lvh\.me/]
  config.non_whitelisted_requests_disabled = true
end

RSpec.configure do |config|
  config.around(:each, type: :feature) do |example|
    WebMock.allow_net_connect!
    example.run
    WebMock.disable_net_connect!
  end
end

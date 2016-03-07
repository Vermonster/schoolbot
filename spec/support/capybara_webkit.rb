require 'capybara/webkit/matchers'

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.allow_url 'lvh.me'
end

RSpec.configure do |config|
  config.after(:each, type: :feature) do |example|
    expect(page).to_not have_errors unless example.metadata[:allow_js_errors]
  end
end

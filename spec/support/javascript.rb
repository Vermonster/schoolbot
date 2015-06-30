RSpec.configure do |config|
  config.before(:each) do |example|
    if example.metadata[:type] == :feature
      Capybara.current_driver = Capybara.javascript_driver
    else
      Capybara.use_default_driver
    end
  end
end

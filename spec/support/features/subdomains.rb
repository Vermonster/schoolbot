module Subdomains
  def use_subdomain(subdomain)
    # lvh.me resolves to 127.0.0.1
    hostname = subdomain ? "#{subdomain}.lvh.me" : "lvh.me"
    Capybara.app_host = "http://#{hostname}"
  end

  def use_root_domain
    use_subdomain nil
  end

  def sign_in_to_district
    use_subdomain('boston')

    visit root_path
    click_on 'Sign In'
    fill_in 'Your email', with: 'bob@example.com'
    fill_in 'Password', with: 'secretpass'
    click_on 'Submit'
  end
end

RSpec.configure do |config|
  config.before(:each, type: :feature) do
    use_root_domain
  end
end

Capybara.configure do |config|
  config.always_include_port = true
end

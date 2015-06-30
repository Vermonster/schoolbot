module Subdomains
  def use_subdomain(subdomain)
    # lvh.me resolves to 127.0.0.1
    hostname = subdomain ? "#{subdomain}.lvh.me" : "lvh.me"
    Capybara.app_host = "http://#{hostname}"
  end

  def use_root_domain
    use_subdomain nil
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

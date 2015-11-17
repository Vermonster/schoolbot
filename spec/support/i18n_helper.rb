module I18nHelper
  delegate :t, to: I18n
  delegate :with_locale, to: I18n
end

RSpec.configure do |config|
  config.around(:each, type: :feature) do |example|
    with_locale(:en) { example.run }
  end
end

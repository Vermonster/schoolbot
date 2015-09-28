require 'rails_helper'

feature 'Locale picker' do
  scenario 'shows the current locale and allows picking a different one' do
    use_subdomain(create(:district).slug)
    visit root_path
    select t('localeName', locale: :en), from: 'Language'
    select t('localeName', locale: :es), from: 'Language'

    expect(page).to have_content t('district.title', locale: :es).upcase
    expect(page).to_not have_content t('district.title', locale: :en).upcase
  end

  scenario 'remembers the selected locale within the same session' do
    use_subdomain(create(:district).slug)
    visit root_path
    select t('localeName', locale: :es), from: 'Language'
    visit root_path

    expect(page).to have_content t('district.title', locale: :es).upcase
  end
end

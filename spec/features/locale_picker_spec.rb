require 'rails_helper'

feature 'Locale picker' do
  scenario 'shows the current locale and allows picking a different one' do
    use_subdomain(create(:district).slug)
    visit root_path
    click_on t('locales.en')
    click_on t('locales.es')

    expect(page).to have_content 'Language: ' + t('locales.es')
    expect(page).to_not have_content t('locales.en')
  end

  scenario 'remembers the selected locale across site visits' do
    use_subdomain(create(:district).slug)
    visit root_path
    click_on t('locales.en')
    click_on t('locales.es')
    visit root_path

    expect(page).to have_content 'Language: ' + t('locales.es')
  end
end

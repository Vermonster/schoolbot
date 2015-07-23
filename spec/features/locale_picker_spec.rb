require 'rails_helper'

feature 'Locale picker' do
  scenario 'shows the current locale and allows picking a different one' do
    visit root_path
    click_on t('locales.en')
    click_on t('locales.es')

    expect(page).to have_content 'Language: ' + t('locales.es')
    expect(page).to_not have_content t('locales.en')
  end
end

require 'rails_helper'

feature 'Global error handler' do
  scenario 'displays a generic message when an unhandled error occurs' do
    mock_api_failure(:sessions, :create)

    use_subdomain(create(:district).slug)
    visit root_path
    click_on t('actions.signIn')
    click_on t('actions.signIn')

    expect(page).to have_content t('flashes.error.generic')
  end
end

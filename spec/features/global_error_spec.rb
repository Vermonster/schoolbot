require 'rails_helper'

feature 'Global error handler' do
  scenario 'displays a generic message when an unhandled error occurs' do
    allow_any_instance_of(API::SessionsController)
      .to receive(:create)
      .and_raise(ActiveRecord::RecordNotFound)

    use_subdomain(create(:district).slug)
    visit root_path
    click_on t('actions.signIn')
    click_on t('actions.signIn')

    expect(page).to have_content t('flashes.error.generic')
  end
end

require 'rails_helper'

feature 'User confirms account' do
  before do
    district = create(:district)
    create(:user, :unconfirmed, district: district, confirmation_token: '1')
    use_subdomain(district.slug)
  end

  scenario 'successfully and is signed in' do
    visit root_path + 'confirm?token=1'

    expect(page).to have_content t('flashes.success.accountConfirmed')
    expect(page).to have_css 'button.btn--settings'
  end

  scenario 'unsuccessfully due to following an invalid link' do
    visit root_path + 'confirm?token=2'

    expect(page).to have_content t('flashes.error.invalidConfirmation')
    expect(page).to have_content t('signIn.title.main').upcase
  end

  # TODO: Test that an unhandled error results in seeing the generic error and
  # being redirected to the sign-in page. Tricky since the relevant action is a
  # direct `visit`, but by that point it's too late for ignoring_ember_errors to
  # set up its stuff.
end

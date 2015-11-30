require 'rails_helper'

feature 'User sets new password' do
  before do
    @district = create(:district)
    use_subdomain(@district.slug)
  end

  scenario 'successfully and is signed in' do
    create(:user, district: @district, reset_password_token: '1')
    visit root_path + 'new-password?token=1'

    fill_in t('labels.password'), with: 'testpass'
    fill_in t('labels.confirmPassword'), with: 'testpass'
    click_on t('actions.changePassword')

    expect(page).to have_content t('flashes.success.passwordReset')
    expect(page).to have_css 'button.btn--settings'
  end

  scenario 'unsuccessfully due to not entering a new password' do
    create(:user, district: @district, reset_password_token: '1')
    visit root_path + 'new-password?token=1'

    click_on t('actions.changePassword')

    expect(page).to have_content t('errors.blank')
  end

  scenario 'unsuccessfully due to entering non-matching passwords' do
    create(:user, district: @district, reset_password_token: '1')
    visit root_path + 'new-password?token=1'

    fill_in t('labels.password'), with: 'testpass'
    fill_in t('labels.confirmPassword'), with: 'testpaas'
    click_on t('actions.changePassword')

    expect(page).to have_content t('errors.passwordConfirmation.confirmation')
  end

  scenario 'unsuccessfully due to following an expired link' do
    create(:user,
      district: @district,
      reset_password_token: '1',
      reset_password_sent_at: 8.days.ago
    )
    visit root_path + 'new-password?token=1'

    expect(page).to have_content t('flashes.error.invalidReset')
    expect(page).to_not have_field t('labels.password')
  end

  scenario 'unsuccessfully due to following an invalid link' do
    create(:user, district: @district, reset_password_token: '1')
    visit root_path + 'new-password?token=2'

    expect(page).to have_content t('flashes.error.invalidReset')
    expect(page).to_not have_field t('labels.password')
  end
end

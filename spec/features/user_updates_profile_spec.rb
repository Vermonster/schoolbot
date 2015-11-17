require 'rails_helper'

feature 'User updates profile' do
  scenario 'and sees the updated information' do
    sign_in_as create(:user)

    click_on t('settings.title')
    click_on t('actions.edit')
    fill_in t('labels.name'), with: 'Guy Test'
    fill_in t('labels.email'), with: 'guy@example.com'
    click_on t('actions.changePassword')
    fill_in t('labels.password'), with: 'secretpass'
    fill_in t('labels.confirmPassword'), with: 'secretpass'
    fill_in t('labels.street'), with: '123 Main St'
    fill_in t('labels.city'), with: 'Someplace'
    fill_in t('labels.state'), with: 'MA'
    click_on t('actions.save')

    expect(page).to_not have_button t('actions.save')
    within('section', text: 'MY INFORMATION') do
      expect(page).to have_content 'Guy Test'
      expect(page).to have_content 'guy@example.com'
      expect(page).to have_content '123 Main St'
      expect(page).to have_content 'Someplace'
      expect(page).to have_content 'MA'
    end
  end

  scenario 'and has their preferred locale persisted' do
    user = create(:user)
    sign_in_as user

    click_on t('settings.title')
    select t('localeName', locale: :fr), from: 'Language'
    sleep 0.5 # the user update request doesn't make it if we reset immediately
    page.driver.reset! # clear any browser storage of the locale
    sign_in_as user

    expect(page).to have_content(
      t('settings.title', locale: :fr).mb_chars.upcase.to_s
    )
  end

  scenario 'and sees error messages when bad data is input' do
    district = create(:district)
    create(:user, district: district, email: 'guy@example.com')
    sign_in_as create(:user, district: district)

    click_on t('settings.title')
    click_on t('actions.edit')
    fill_in t('labels.email'), with: 'guy@example.com'
    click_on t('actions.changePassword')
    fill_in t('labels.password'), with: 'secret'
    fill_in t('labels.confirmPassword'), with: 'sorcret'
    fill_in t('labels.street'), with: ''
    click_on t('actions.save')

    expect(page).to have_content t('errors.email.taken')
    expect(page).to have_content t('errors.password.too_short')
    expect(page).to have_content t('errors.passwordConfirmation.confirmation')
  end

  scenario 'and sees a generic message when an unhandled error occurs' do
    mock_api_failure(:users, :update)
    sign_in_as create(:user)

    click_on t('settings.title')
    click_on t('actions.edit')

    ignoring_ember_errors do
      click_on t('actions.save')
      expect(page).to have_content t('flashes.error.generic')
    end
  end
end

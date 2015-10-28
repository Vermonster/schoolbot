require 'rails_helper'

feature 'User signs in' do
  before do
    district = create(:district, slug: 'boston')
    create(:user,
      district: district,
      email: 'bob@example.com',
      password: 'secretpass'
    )
  end

  scenario 'successfully and is sent to the main page' do
    use_subdomain('boston')

    visit root_path
    click_on t('actions.signIn')
    fill_in t('labels.email'), with: 'bob@example.com'
    fill_in t('labels.password'), with: 'secretpass'
    click_on t('actions.signIn')

    expect(page).to have_css 'button.btn--settings'
  end

  scenario 'unsuccessfully due to invalid credentials' do
    use_subdomain('boston')

    visit root_path
    click_on t('actions.signIn')
    fill_in t('labels.email'), with: 'bob@example.com'
    fill_in t('labels.password'), with: ''
    click_on t('actions.signIn')

    expect(page).to have_content t('errors.session.invalid')
  end

  scenario 'unsuccessfully due to using the wrong subdomain' do
    create(:district, slug: 'district13')
    use_subdomain('district13')

    visit root_path
    click_on t('actions.signIn')
    fill_in t('labels.email'), with: 'bob@example.com'
    fill_in t('labels.password'), with: 'secretpass'
    click_on t('actions.signIn')

    expect(page).to have_content t('errors.session.invalid')
  end

  scenario 'and sees a generic message when an unhandled error occurs' do
    mock_api_failure(:sessions, :create)
    use_subdomain('boston')

    visit root_path
    click_on t('actions.signIn')
    click_on t('actions.signIn')

    expect(page).to have_content t('flashes.error.generic')
  end
end

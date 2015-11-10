require 'rails_helper'

feature 'User signs in' do
  before do
    @district = create(:district, slug: 'boston')
    use_subdomain('boston')
  end

  context 'with a confirmed account' do
    before do
      create(:user,
        district: @district,
        email: 'bob@example.com',
        password: 'secretpass'
      )
    end

    scenario 'successfully and is sent to the main page' do
      visit root_path
      click_on t('actions.signIn')
      fill_in t('labels.email'), with: 'bob@example.com'
      fill_in t('labels.password'), with: 'secretpass'
      click_on t('actions.signIn')

      expect(page).to have_css 'button.btn--settings'
    end

    scenario 'unsuccessfully due to invalid credentials' do
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
  end

  scenario 'unsuccessfully with an unconfirmed account' do
    create(:user, :unconfirmed,
      district: @district,
      email: 'bob@example.com',
      password: 'secretpass'
    )

    visit root_path
    click_on t('actions.signIn')
    fill_in t('labels.email'), with: 'bob@example.com'
    fill_in t('labels.password'), with: 'secretpass'
    click_on t('actions.signIn')

    expect(page).to have_content t('errors.session.invalid')
  end

  scenario 'and sees a generic message when an unhandled error occurs' do
    mock_api_failure(:sessions, :create)

    visit root_path
    click_on t('actions.signIn')

    ignoring_ember_errors do
      click_on t('actions.signIn')
      expect(page).to have_content t('flashes.error.generic')
    end
  end
end

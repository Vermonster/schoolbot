require 'rails_helper'

feature 'User resets password' do
  scenario 'and receives a password change link via email', :perform_jobs do
    district = create(:district, slug: 'boston')
    use_subdomain('boston')
    create(:user,
      district: district,
      email: 'ann@example.com',
      locale: 'en'
    )

    visit root_path
    click_on t('actions.signIn')
    click_on t('signIn.forgot')
    fill_in t('labels.email'), with: 'ann@example.com'
    click_on t('resetPassword.title')

    expect(page).to have_content(
      t('resetPassword.success').sub('{{email}}', 'ann@example.com')
    )
    expect(mailbox_for('ann@example.com')).to have(1).message

    open_email('ann@example.com', subject: t('emails.resetPassword.subject'))
    click_first_link_in_email
    fill_in t('labels.password'), with: 'testpass'
    fill_in t('labels.confirmPassword'), with: 'testpass'
    click_on t('actions.changePassword')

    expect(page).to have_content t('flashes.success.passwordReset')
    expect(page).to have_css 'button.btn--settings'
  end

  scenario 'with an error if the entered email address does not exist' do
    use_subdomain(create(:district).slug)

    visit root_path
    click_on t('actions.signIn')
    click_on t('signIn.forgot')
    fill_in t('labels.email'), with: 'ann@example.com'
    click_on t('resetPassword.title')

    expect(page).to have_content t('resetPassword.error')
    expect(mailbox_for('ann@example.com')).to be_empty
  end

  scenario 'with a generic message when an unhandled error occurs' do
    mock_api_failure(:password_resets, :create)
    use_subdomain(create(:district).slug)

    visit root_path
    click_on t('actions.signIn')
    click_on t('signIn.forgot')

    ignoring_ember_errors do
      click_on t('resetPassword.title')
      expect(page).to have_content t('flashes.error.generic')
    end
  end
end

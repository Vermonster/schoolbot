require 'rails_helper'

feature 'User creates account' do
  scenario 'and signs in via an emailed confirmation link' do
    district = create(:district)
    create(:school, district: district, name: 'Springfield High')
    student = create(:student,
      district: district,
      digest: Digest::SHA256.hexdigest('abc123:test:2002-03-21')
    )
    bus = create(:bus, district: district)
    create(:bus_assignment, student: student, bus: bus)
    create(:bus_location, bus: bus)
    use_subdomain(district.slug)

    visit root_path
    select t('localeName', locale: :pt), from: 'Language'
    with_locale(:pt) do
      click_on t('actions.register')
      fill_in t('labels.name'), with: 'Guy Test'
      fill_in t('labels.email'), with: 'guy@example.com'
      fill_in t('labels.password'), with: 'secretpass'
      fill_in t('labels.confirmPassword'), with: 'secretpass'
      fill_in t('labels.street'), with: '123 Main St'
      fill_in t('labels.city'), with: 'Someplace'
      fill_in t('labels.state'), with: 'MA'
      fill_in t('labels.zip'), with: '12345'
      fill_in t('labels.nickname'), with: 'Johnny'
      fill_in t('labels.lastName'), with: 'Test'
      fill_in t('labels.identifier'), with: 'ABC123'
      fill_in t('labels.birthdate'), with: '3/21/2002'
      select 'Springfield High', from: t('labels.school')
      check t('labels.termsAccepted')
      click_on t('createAccount.cta')

      expect(page).to have_content(
        t('createAccount.success.heading').mb_chars.upcase.to_s
      )
      expect(page).to have_content(
        t('createAccount.success.copy').sub('{{email}}', 'guy@example.com')
      )
      expect(mailbox_for('guy@example.com')).to have(1).message

      open_email('guy@example.com', subject: t('emails.confirmAccount.subject'))
      click_first_link_in_email

      expect(page).to have_content t('flashes.success.accountConfirmed')
      expect(page).to have_css 'button.btn--settings'
      within('.leaflet-container') do
        expect(page).to have_css('.bus-marker', text: 'J')
      end
    end
  end

  scenario 'and sees error messages if bad data is input' do
    district = create(:district)
    create(:user, district: district, email: 'guy@example.com')
    use_subdomain(district.slug)

    visit root_path
    click_on t('actions.register')
    fill_in t('labels.email'), with: 'guy@example.com'
    fill_in t('labels.password'), with: 'secret'
    fill_in t('labels.confirmPassword'), with: 'sorcret'
    fill_in t('labels.lastName'), with: 'Test'
    fill_in t('labels.identifier'), with: 'ABC123'
    fill_in t('labels.birthdate'), with: '2002-03-2'
    click_on t('createAccount.cta')

    expect(page).to have_content t('errors.blank'), count: 1
    expect(page).to have_content t('errors.email.taken')
    expect(page).to have_content t('errors.password.too_short')
    expect(page).to have_content t('errors.passwordConfirmation.confirmation')
    expect(page).to have_content t('errors.digest.blank')
    expect(page).to have_content t('errors.birthdate.invalid')
    expect(page).to have_content t('errors.school.blank')
    expect(page).to have_content t('errors.accepted')
    expect(page).to_not have_content t('errors.address.invalid')
    expect(mailbox_for('guy@example.com')).to be_empty
  end

  scenario 'and sees an error message if their address could not be found' do
    Geocoder::Lookup::Test.add_stub('123 Main St, Someplace, MA, 12345', [])
    use_subdomain(create(:district).slug)

    visit root_path
    click_on t('actions.register')
    fill_in t('labels.street'), with: '123 Main St'
    fill_in t('labels.city'), with: 'Someplace'
    fill_in t('labels.state'), with: 'MA'
    fill_in t('labels.zip'), with: '12345'
    click_on t('createAccount.cta')

    expect(page).to have_content t('errors.address.invalid')
  end

  scenario 'and sees a generic message when an unhandled error occurs' do
    mock_api_failure(:registrations, :create)
    use_subdomain(create(:district).slug)

    visit root_path
    click_on t('actions.register')

    ignoring_ember_errors do
      click_on t('createAccount.cta')
      expect(page).to have_content t('flashes.error.generic')
    end
  end
end

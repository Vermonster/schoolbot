require 'rails_helper'

feature 'User creates account' do
  scenario 'and is signed into the app with their first student added' do
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
    click_on 'Create one now'
    fill_form(:registration,
      'Full name' => 'Guy Test',
      'Email address' => 'guy@example.com',
      'Password' => 'secretpass',
      'Confirm password' => 'secretpass',
      'Street' => '123 Main St',
      'City' => 'Someplace',
      'State' => 'MA',
      'ZIP code' => '12345',
      'Last Name' => 'Test',
      'Student ID' => 'ABC123',
      'Birthdate' => '3/21/2002',
      'Nickname' => 'Johnny',
      'School' => 'Springfield High',
      'I accept the terms and conditions' => true
    )
    click_on 'Register'

    expect(page).to have_css 'button.btn--settings', wait: 5
    within('.leaflet-container') do
      expect(page).to have_css('.bus-marker', text: 'JO')
    end
  end

  scenario 'and sees error messages if bad data is input' do
    district = create(:district)
    create(:user, district: district, email: 'guy@example.com')
    use_subdomain(district.slug)

    visit root_path
    click_on 'Create one now'
    fill_form(:registration,
      'Email address' => 'guy@example.com',
      'Password' => 'secret',
      'Confirm password' => 'sorcret',
      'Last Name' => 'Test',
      'Student ID' => 'ABC123',
      'Birthdate' => '2002-03-21'
    )
    click_on 'Register'

    expect(page).to have_content t('errors.blank'), count: 5
    expect(page).to have_content t('errors.email.taken')
    expect(page).to have_content t('errors.password.too_short')
    expect(page).to have_content t('errors.passwordConfirmation.confirmation')
    expect(page).to have_content t('errors.digest.blank')
    expect(page).to have_content t('errors.birthdate.invalid')
    expect(page).to have_content t('errors.school.blank')
    expect(page).to have_content t('errors.accepted')
    expect(page).to_not have_content t('errors.address.invalid')
  end

  scenario 'and sees an error message if their address could not be found' do
    Geocoder::Lookup::Test.add_stub('123 Main St, Someplace, MA, 12345', [])
    use_subdomain(create(:district).slug)

    visit root_path
    click_on 'Create one now'
    fill_form(:registration,
      'Street' => '123 Main St',
      'City' => 'Someplace',
      'State' => 'MA',
      'ZIP code' => '12345'
    )
    click_on 'Register'

    expect(page).to have_content t('errors.address.invalid')
  end
end

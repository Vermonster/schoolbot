require 'rails_helper'

feature 'User adds student' do
  scenario 'and sees the student added to the list' do
    district = create(:district)
    create(:school, district: district, name: 'Springfield Elementary')
    student = create(:student, district: district, digest: student_digest)
    bus = create(:bus, district: district, identifier: 'BUS001')
    create(:bus_assignment, student: student, bus: bus)
    sign_in_as create(:user, district: district)

    click_on t('settings.title')
    click_on t('actions.addStudent')
    fill_in_student_information
    select 'Springfield Elementary', from: t('labels.school')
    click_on 'Save'

    expect(page).to_not have_button t('actions.save')
    within('section', text: 'MY STUDENTS') do
      within('li', text: 'Danny') do
        expect(page).to have_css '.student__nickname', text: 'D'
        expect(page).to have_content 'Springfield Elementary'
      end
    end
  end

  scenario 'and sees error messages when bad data is input' do
    district = create(:district)
    user = create(:user, district: district)
    student = create(:student, district: district, digest: student_digest)
    create(:student_label,
      school: create(:school, district: district),
      student: student,
      user: user,
      nickname: 'Danny'
    )
    sign_in_as user

    click_on t('settings.title')
    click_on t('actions.addStudent')
    fill_in_student_information
    click_on t('actions.save')

    expect(page).to have_button t('actions.save')
    expect(page).to have_content t('errors.digest.taken')
    expect(page).to have_content t('errors.nickname.taken')
    expect(page).to have_content t('errors.school.blank')
    expect(page).to_not have_content t('errors.birthdate.invalid')
  end

  scenario 'and sees an error message if the birthdate is invalid' do
    sign_in_as create(:user)

    click_on t('settings.title')
    click_on t('actions.addStudent')
    fill_in t('labels.birthdate'), with: '2003-05-27'
    # Change the focus so the birthdate validation occurs
    fill_in t('labels.nickname'), with: ''

    expect(page).to have_content t('errors.birthdate.invalid')
  end

  scenario 'and sees a generic message on unhandled errors', :allow_js_errors do
    mock_api_failure(:students, :create)
    sign_in_as create(:user)

    click_on t('settings.title')
    click_on t('actions.addStudent')
    click_on t('actions.save')

    expect(page).to have_content t('flashes.error.generic')
  end

  def fill_in_student_information
    fill_in t('labels.nickname'), with: 'Danny'
    fill_in t('labels.lastName'), with: 'Smith'
    fill_in t('labels.identifier'), with: 'A1234'
    fill_in t('labels.birthdate'), with: '5/27/2003'
  end

  def student_digest
    Digest::SHA256.hexdigest('a1234:smith:2003-05-27')
  end
end

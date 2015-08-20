require 'rails_helper'

feature 'User adds student' do
  scenario 'and sees the student added to the list' do
    district = create(:district)
    create(:school, district: district, name: 'Springfield Elementary')
    user = create(:user, district: district)
    student = create(:student,
      district: district,
      digest: Digest::SHA256.hexdigest('a1234:smith:2003-05-27')
    )
    bus = create(:bus, district: district, identifier: 'BUS001')
    create(:bus_assignment, student: student, bus: bus)

    sign_in_as user

    find('[aria-label="Settings"]').click
    click_on 'Add student'
    fill_in 'Last Name', with: 'Smith'
    fill_in 'Student ID', with: 'A1234'
    fill_in 'Birthdate', with: '5/27/2003'
    fill_in 'Nickname', with: 'Danny'
    select 'Springfield Elementary', from: 'School'
    click_on 'Save'

    expect(page).to_not have_button 'Save'
    within('section', text: 'MY STUDENTS') do
      within('li', text: 'Danny') do
        expect(page).to have_content 'DA'
        expect(page).to have_content 'Springfield Elementary'
      end
    end
  end

  scenario 'and sees error messages when bad data is input' do
    district = create(:district)
    user = create(:user, district: district)
    create(:student_label,
      school: create(:school, district: district),
      student: create(:student, district: district),
      user: user,
      nickname: 'Danny'
    )
    sign_in_as user

    find('[aria-label="Settings"]').click
    click_on 'Add student'
    fill_in 'Last Name', with: 'Smith'
    fill_in 'Student ID', with: 'A1234'
    fill_in 'Birthdate', with: '5/27/2003'
    fill_in 'Nickname', with: 'Danny'
    click_on 'Save'

    expect(page).to have_button 'Save'
    expect(page).to have_content t('errors.digest.blank')
    expect(page).to have_content t('errors.nickname.taken')
    expect(page).to have_content t('errors.school.blank')
    expect(page).to_not have_content t('errors.birthdate.invalid')
  end

  scenario 'and sees an error message if the birthdate is invalid' do
    sign_in_as create(:user)

    find('[aria-label="Settings"]').click
    click_on 'Add student'
    fill_in 'Birthdate', with: '2003-05-27'

    expect(page).to have_content t('errors.birthdate.invalid')
  end
end

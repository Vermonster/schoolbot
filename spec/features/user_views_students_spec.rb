require 'rails_helper'

feature 'User views students' do
  scenario 'and sees a list of nicknames and schools' do
    district = create(:district)
    user = create(:user, district: district)
    create(:student_label,
      school: create(:school, name: 'Middle School'),
      student: create(:student, district: district),
      user: user,
      nickname: 'First Student'
    )
    create(:student_label,
      school: create(:school, name: 'High School'),
      student: create(:student, district: district),
      user: user,
      nickname: 'Second Student'
    )
    sign_in_as user

    within('.menu') do
      click_on t('settings.title')
    end

    within('section', text: 'MY STUDENTS') do
      within('li', text: 'First Student') do
        expect(page).to have_content 'FI'
        expect(page).to have_content 'Middle School'
      end
      within('li', text: 'Second Student') do
        expect(page).to have_content 'SE'
        expect(page).to have_content 'High School'
      end
    end
  end
end

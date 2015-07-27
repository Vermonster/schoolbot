require 'rails_helper'

feature 'User adds and removes student' do
  before do
    district = create(:district, slug: 'boston')
    create(:user,
      district: district,
      email: 'bob@example.com',
      password: 'secretpass'
    )
  end

  scenario 'successfully and dismisses the modal' do
    sign_in_to_district
    count = Student.count

    expect(page).to have_content 'Signed into district'

    click_on 'My Account'

    within '.modal' do
      expect(page).to have_content 'My Students'

      fill_in 'Last Name', with: 'lewis'
      fill_in 'Student ID', with: '139392'
      fill_in 'Birthday MM/DD/YYYY', with: '8/27/2003'
      fill_in 'Nickname', with: 'lew'
      select 'Baker School', :from =>'Select School...'
      click_on 'Add'

      expect(page).to have_content 'You successfully added a student'
      expect(Student.count).to eq(count + 1)

      click_on 'Close'
    end

    expect(page).to_not have_content 'Student Information'
  end

  scenario 'unsuccessfully because the student does not exist in the database' do
    sign_in_to_district

    click_on 'My Account'

    expect(page).to have_button('Add', disabled: true)

    within '.student-info' do
      fill_in 'Last Name', with: 'does not exist'
      fill_in 'Student ID', with: '139392'
      fill_in 'Birthday MM/DD/YYYY', with: 'abc'

      expect(page).to have_content 'Invalid format'

      fill_in 'Birthday MM/DD/YYYY', with: '8/27/2003'
      select 'Baker School', :from =>'Select School...'
      fill_in 'Nickname', with: 'lew'
      click_on 'Add'

      expect(page).to have_content 'No student is found'
    end
  end

end

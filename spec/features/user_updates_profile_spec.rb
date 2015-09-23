require 'rails_helper'

feature 'User updates profile' do
  scenario 'and sees the updated information' do
    sign_in_as create(:user)

    find('[aria-label="Settings"]').click
    click_on 'Edit'
    fill_in 'Name', with: 'Guy Test'
    fill_in 'Email', with: 'guy@example.com'
    click_on 'Change Password'
    fill_in 'Password', with: 'secretpass'
    fill_in 'Confirm Password', with: 'secretpass'
    fill_in 'Street', with: '123 Main St'
    fill_in 'City', with: 'Someplace'
    fill_in 'State', with: 'MA'
    click_on 'Save'

    expect(page).to_not have_button 'Save'
    within('section', text: 'MY INFORMATION') do
      expect(page).to have_content 'Guy Test'
      expect(page).to have_content 'guy@example.com'
      expect(page).to have_content '123 Main St'
      expect(page).to have_content 'Someplace'
      expect(page).to have_content 'MA'
    end
  end

  scenario 'and sees error messages when bad data is input' do
    district = create(:district)
    create(:user, district: district, email: 'guy@example.com')
    sign_in_as create(:user, district: district)

    find('[aria-label="Settings"]').click
    click_on 'Edit'
    fill_in 'Email', with: 'guy@example.com'
    click_on 'Change Password'
    fill_in 'Password', with: 'secret'
    fill_in 'Confirm Password', with: 'sorcret'
    fill_in 'Street', with: ''
    click_on 'Save'

    expect(page).to have_content t('errors.email.taken')
    expect(page).to have_content t('errors.password.too_short')
    expect(page).to have_content t('errors.passwordConfirmation.confirmation')
  end
end

require 'rails_helper'

feature 'User views profile' do
  scenario 'and sees their profile attributes listed' do
    user = create(:user,
      email: 'earl@example.com',
      name: 'Earl Rogers',
      street: '123 Main St',
      city: 'Los Angeles',
      state: 'CA',
      zip_code: '90001'
    )
    sign_in_as user

    within('.menu') do
      click_on t('map.settings')
    end

    within('section', text: 'MY INFORMATION') do
      expect(page).to have_content 'earl@example.com'
      expect(page).to have_content 'Earl Rogers'
      expect(page).to have_content '123 Main St'
      expect(page).to have_content 'Los Angeles'
      expect(page).to have_content 'CA'
      expect(page).to have_content '90001'
    end
  end
end

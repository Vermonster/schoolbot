require 'rails_helper'

feature 'User views help dialog' do
  scenario 'and sees district email and phone number' do
    district = create(:district, contact_phone: '555-5678', contact_email: 'tester@example.com')
    sign_in_as create(:user, district: district)

    within('.menu') do
      click_on t('help.title')
    end

    expect(page).to have_content '555-5678'
    expect(page).to have_content 'tester@example.com'
  end
end

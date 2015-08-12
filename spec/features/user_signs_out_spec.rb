require 'rails_helper'

feature 'User signs out' do
  scenario 'and is sent to the sign-in page' do
    sign_in_as create(:user)

    click_on 'Settings'

    within('.modal') do
      click_on 'Sign Out'
    end

    expect(page).to have_content 'SIGN IN'
  end
end

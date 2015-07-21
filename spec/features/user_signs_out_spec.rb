require 'rails_helper'

feature 'User signs out' do
  before do
    district = create(:district, slug: 'boston')
    create(:user, district: district, email: 'a@b.com', password: 'testpass')
    use_subdomain('boston')
    visit root_path
    click_on 'Sign In'
    fill_in 'Your email', with: 'a@b.com'
    fill_in 'Password', with: 'testpass'
    click_on 'Submit'
  end

  scenario 'and is sent to the sign-in page' do
    click_on 'Sign Out'

    expect(page).to have_content 'Please login'
  end
end

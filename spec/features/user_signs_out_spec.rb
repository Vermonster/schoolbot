require 'rails_helper'

feature 'User signs out' do
  scenario 'and is sent to the sign-in page' do
    sign_in_as create(:user)

    within('.menu') do
      find('[aria-label="Settings"]').click
    end

    within('.modal') do
      click_on t('actions.signOut')
    end

    expect(page).to have_content t('actions.signIn').upcase
    expect(page).to have_content t('actions.register').upcase
  end
end

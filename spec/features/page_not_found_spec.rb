require 'rails_helper'

feature 'Page not found' do
  scenario 'appears when a nonexistent path is accessed on the root domain' do
    use_root_domain

    visit '/sign%20in'

    expect(page).to have_content 'NOTHING HERE'
    expect(page).to have_link 'home page', href: '/'
  end

  scenario 'appears when a nonexistent path is accessed on a district domain' do
    use_subdomain create(:district).slug

    visit '/sign%20in'

    expect(page).to have_content 'NOTHING HERE'
    expect(page).to have_link 'home page', href: '/'
  end
end

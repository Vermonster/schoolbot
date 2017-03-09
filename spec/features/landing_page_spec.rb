require 'rails_helper'

feature 'Landing page' do
  scenario 'shows the "About" page when accessed at the root domain' do
    use_root_domain

    visit root_path

    expect(page).to have_content 'WELCOME!'
  end

  scenario 'redirects to the root domain when accessed at "www" subdomain' do
    use_subdomain 'www'

    visit root_path

    expect(page).to have_content 'WELCOME!'
    expect(current_url).to_not include 'www'
  end

  scenario 'shows the district name and logo when accessed at a subdomain' do
    create(:district, name: 'District Foo')
    district = create(:district, name: 'District Qux', slug: 'qux')
    use_subdomain 'qux'

    visit root_path

    expect(page).to have_content 'DISTRICT QUX'
    expect(page).to have_css "img[src='#{district.logo.url}']"
    expect(page).to_not have_content 'DISTRICT FOO'
  end

  scenario 'submission made through contact form' do
    visit root_path
    expect(page).to have_content 'CONTACT US'

    fill_in 'Name', with: 'David'
    fill_in 'Email', with: 'schoolbotty@example.com'
    fill_in 'Message', with: 'Yay Schoolbot'
    click_button 'Send'

    expect(page).to have_content "Thanks, David, we'll get in touch with you soon!"
  end
end

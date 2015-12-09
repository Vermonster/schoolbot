require 'rails_helper'

feature 'Landing page' do
  scenario 'shows the "About" page when accessed at the root domain' do
    use_root_domain

    visit root_path

    expect(page).to have_content 'WELCOME!'
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

  scenario 'shows an error message when accessed at an invalid subdomain' do
    use_subdomain 'qux'

    visit root_path

    expect(page).to have_content 'DISTRICT NOT FOUND'
  end

  scenario 'shows an error message when the relevant district is inactive' do
    create(:district, slug: 'bar', is_active: false)
    use_subdomain 'bar'

    visit root_path

    expect(page).to have_content 'DISTRICT NOT FOUND'
  end
end

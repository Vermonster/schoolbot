require 'rails_helper'

feature 'Landing page' do
  scenario 'shows the "About" page when accessed at the root domain' do
    use_root_domain

    visit root_path

    expect(page).to have_content 'WELCOME'
  end

  scenario 'shows the district name when accessed at a district subdomain' do
    create(:district, name: 'District Foo')
    create(:district, name: 'District Qux', slug: 'qux')
    use_subdomain 'qux'

    visit root_path

    expect(page).to have_content 'District Qux'
    expect(page).to_not have_content 'District Foo'
  end
end

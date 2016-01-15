require 'rails_helper'

feature 'District not found' do
  scenario 'appears when an invalid subdomain is accessed' do
    use_subdomain 'qux'

    visit root_path

    expect(page).to have_content 'DISTRICT NOT FOUND'
  end

  scenario 'appears when a valid path is accessed at an invalid subdomain' do
    use_subdomain 'qux'

    visit '/sign-in'

    expect(page).to have_content 'DISTRICT NOT FOUND'
  end

  scenario 'appears when the relevant district is inactive' do
    create(:district, slug: 'bar', is_active: false)
    use_subdomain 'bar'

    visit root_path

    expect(page).to have_content 'DISTRICT NOT FOUND'
  end
end

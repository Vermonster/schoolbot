require 'rails_helper'

describe 'Districts API' do
  it 'does not expose customer secrets' do
    district = create(:district, slug: 'baz')

    get api_current_district_url(subdomain: 'baz')

    expect(response).to be_successful
    district_values = response_json[:district].values
    expect(district_values).to_not include district.api_secret
    expect(district_values).to_not include district.zonar_customer
    expect(district_values).to_not include district.zonar_username
    expect(district_values).to_not include district.zonar_password
  end

  it 'includes the URL of the district logo' do
    district = create(:district)

    get api_current_district_url(subdomain: district.slug)

    expect(response).to be_successful
    expect(response_json[:district][:logo_url]).to eq district.logo.url
  end

  it 'includes school information' do
    district = create(:district, slug: 'baz')
    create(:school, district: district, name: 'middle')
    create(:school, district: district, name: 'elementary')

    get api_current_district_url(subdomain: 'baz')

    expect(response).to be_successful
    expect(response_json).to have_key :schools
    expect(response_json[:schools]).to have(2).items
  end
end

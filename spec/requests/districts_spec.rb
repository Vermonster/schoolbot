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
end

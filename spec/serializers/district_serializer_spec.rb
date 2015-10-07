require 'rails_helper'

describe DistrictSerializer do
  it 'does not expose customer secrets' do
    district = build(:district)

    json_string = described_class.new(district).to_json

    expect(json_string).to_not include district.api_secret
    expect(json_string).to_not include district.zonar_customer
    expect(json_string).to_not include district.zonar_username
    expect(json_string).to_not include district.zonar_password
  end
end

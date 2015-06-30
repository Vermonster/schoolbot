require 'rails_helper'

describe District do
  describe '#after_initialize' do
    it 'generates a random API secret' do
      district = District.new

      expect(district.api_secret).to be_present
    end

    it 'does not overwrite an existing API secret' do
      api_secret = create(:district).api_secret
      district = District.first # re-initialize

      expect(district.api_secret).to eq api_secret
    end
  end
end

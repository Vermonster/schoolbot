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

  describe 'validation' do
    it 'downcases and removes all whitespace from the contact email address' do
      district = build(:district, contact_email: ' Test @Example.com  ')

      district.validate!

      expect(district.contact_email).to eq 'test@example.com'
    end
  end
end

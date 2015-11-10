require 'rails_helper'

describe 'Confirmations API' do
  describe 'create action' do
    it 'confirms a user and returns the user email and token' do
      district = create(:district, slug: 'pip')
      user = create(:user, :unconfirmed,
        district: district,
        email: 'bob@example.com',
        confirmation_token: 'A',
        authentication_token: 'B'
      )

      post api_confirmations_url(subdomain: 'pip'), confirmation: { token: 'A' }

      expect(response.status).to be 201
      expect(response_json).to eq(
        confirmation: {
          user_email: 'bob@example.com',
          user_token: 'B'
        }
      )
      expect(user.reload).to be_confirmed
    end

    it 'returns error information if the token is invalid' do
      district = create(:district, slug: 'bop')
      create(:user, district: district, confirmation_token: 'C')

      post api_confirmations_url(subdomain: 'bop'), confirmation: { token: 'X' }

      expect(response.status).to be 422
      expect(response_json[:errors]).to eq(user: ['blank'])
    end
  end
end

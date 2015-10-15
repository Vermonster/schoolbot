require 'rails_helper'

describe 'Sessions API' do
  before do
    @district = create(:district, slug: 'foo')
  end

  it 'requires correct parameters' do
    post api_sessions_url(subdomain: 'foo'), user: { password: 'nope' }

    expect(response.status).to be 422
  end

  context 'with an existing user' do
    before do
      create(:user,
        district: @district,
        email: 'test@example.com',
        password: 'swordfish',
        authentication_token: 'supersecret'
      )
    end

    it 'returns an authentication token, ignoring case of the email address' do
      post api_sessions_url(subdomain: 'foo'), user: {
        email: '  Test@Example.com ',
        password: 'swordfish'
      }

      expect(response).to be_successful
      expect(response_json).to eq(token: 'supersecret', email: 'test@example.com')
    end

    it 'returns an error with invalid credentials' do
      post api_sessions_url(subdomain: 'foo'), user: {
        email: 'test@example.com',
        password: 'catfish'
      }

      expect(response.status).to be 401
      expect(response_json).to eq(error: 'errors.session.invalid')
    end
  end
end

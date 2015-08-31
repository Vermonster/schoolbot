require 'rails_helper'

describe 'Current user API' do
  include ActionController::HttpAuthentication::Token

  def auth_headers(user)
    {
      'HTTP_AUTHORIZATION' => encode_credentials(
        user.authentication_token, email: user.email
      )
    }
  end

  def invalid_auth_headers
    { 'HTTP_AUTHORIZATION' => encode_credentials('nope', email: 'invalid') }
  end

  describe 'update action' do
    it 'cannot be accessed without authentication' do
      create(:district, slug: 'qux')

      get api_students_url(subdomain: 'qux'), nil, invalid_auth_headers

      expect(response.status).to be 401
    end

    it 'updates attributes for the current user regardless of the ID passed' do
      district = create(:district, slug: 'foo')
      target_user, other_user = create_list(:user, 2, district: district)
      previous_digest = target_user.password_digest
      new_attributes = {
        name: 'tester',
        email: 'tester@example.com',
        password: 'secretpass',
        password_confirmation: 'secretpass',
        street: '123 main st',
        city: 'someplace',
        state: 'MA',
        zip_code: '98765'
      }

      url = api_update_current_user_url(other_user.id, subdomain: 'foo')
      put url, { user: new_attributes }, auth_headers(target_user)

      expect(response.status).to be 204
      target_user.reload
      expect(target_user.email).to eq 'tester@example.com'
      expect(target_user.zip_code).to eq '98765'
      expect(target_user.password_digest).to_not eq previous_digest
    end

    it 'does not change the password if a blank password is provided' do
      district = create(:district, slug: 'bip')
      user = create(:user, district: district)
      previous_digest = user.password_digest
      new_attributes = {
        name: 'tester',
        password: '',
        password_confirmation: ''
      }

      url = api_update_current_user_url(user.id, subdomain: 'bip')
      put url, { user: new_attributes }, auth_headers(user)

      expect(response.status).to be 204
      expect(user.reload.password_digest).to eq previous_digest
    end

    it 'returns error information if the attributes are invalid' do
      district = create(:district, slug: 'bop')
      user = create(:user, district: district)
      create(:user, district: district, email: 'test@example.com')
      new_attributes = {
        name: '',
        email: 'test@example.com',
        password: 'secret',
        password_confirmation: 'sorcret',
        street: '',
        city: '',
        state: '',
        zip_code: ''
      }

      url = api_update_current_user_url(user.id, subdomain: 'bop')
      put url, { user: new_attributes }, auth_headers(user)

      expect(response.status).to be 422
      expect(response_json[:errors]).to eq(
        city: ['blank'],
        email: ['taken'],
        name: ['blank'],
        password: ['too_short'],
        password_confirmation: ['confirmation'],
        state: ['blank'],
        street: ['blank'],
        zip_code: ['blank']
      )
    end
  end
end

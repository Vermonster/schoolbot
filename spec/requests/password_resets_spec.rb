require 'rails_helper'

describe 'Password resets API' do
  describe 'show action' do
    it 'returns the email address for a given password reset token' do
      district = create(:district, slug: 'pep')
      user = create(:user, district: district, reset_password_token: 'abc1')

      get api_password_reset_url('abc1', subdomain: 'pep')

      expect(response).to be_successful
      expect(response_json).to eq(
        password_reset: { id: 'abc1', email: user.email }
      )
    end

    it 'returns 404 when the password reset token cannot be found' do
      create(:district, slug: 'pep')

      get api_password_reset_url('abc1', subdomain: 'pep')

      expect(response.status).to be 404
    end
  end

  describe 'create action' do
    it 'enables the corresponding user for password resets' do
      district = create(:district, slug: 'pep')
      user = create(:user, district: district, email: 'bab@example.com')

      post(
        api_password_resets_url(subdomain: 'pep'),
        password_reset: { email: 'bab@example.com' }
      )

      expect(response.status).to be 201
      expect(response_json).to eq(
        password_reset: {
          id: user.reload.reset_password_token,
          email: 'bab@example.com'
        }
      )
      expect(user.reset_password_token).to be_present
      expect(user.reset_password_sent_at).to be_present
    end

    it 'returns error information if the email is not found' do
      create(:district, slug: 'pep')

      post(
        api_password_resets_url(subdomain: 'pep'),
        password_reset: { email: 'nope@example.com' }
      )

      expect(response.status).to be 422
      expect(response_json[:errors]).to eq(user: ['blank'])
    end
  end

  describe 'update action' do
    it 'sets a new password and disables password resets for the user' do
      district = create(:district, slug: 'pep')
      user = create(:user, district: district, reset_password_token: 'xyz2')

      patch(
        api_password_reset_url('xyz2', subdomain: 'pep'),
        password_reset: {
          password: 'testpass',
          password_confirmation: 'testpass'
        }
      )

      expect(response.status).to be 204
      expect(user.reload.authenticate('testpass')).to be_truthy
      expect(user.reset_password_token).to_not be_present
    end

    it 'returns error information if the password does not validate' do
      district = create(:district, slug: 'pep')
      create(:user, district: district, reset_password_token: 'xyz4')

      patch(
        api_password_reset_url('xyz4', subdomain: 'pep'),
        password_reset: {
          password: 'tst',
          password_confirmation: 'testpass'
        }
      )

      expect(response.status).to be 422
      expect(response_json[:errors]).to eq(
        password: ['too_short'],
        password_confirmation: ['confirmation']
      )
    end
  end
end

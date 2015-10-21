require 'rails_helper'

describe 'Registrations API' do
  describe 'create action' do
    it 'creates a new user account with a student label' do
      district = create(:district, slug: 'baz')
      school = create(:school, district: district)
      create(:student, district: district, digest: 'abc12345' * 8)
      data = {
        name: 'tester',
        email: 'tester@example.com',
        password: 'secretpass',
        password_confirmation: 'secretpass',
        street: '123 main st',
        city: 'someplace',
        state: 'MA',
        zip_code: '98765',
        digest: 'abc12345' * 8,
        nickname: 'dave',
        school_id: school.id,
        terms_accepted: true
      }

      post api_registrations_url(subdomain: 'baz'), registration: data

      expect(response.status).to be 201
      expect(response_json).to eq(registration: { id: User.last.id })
      expect(district.users.count).to be 1
      expect(district.users.first.student_labels.count).to be 1
    end

    it 'returns error information if the registration is invalid' do
      district = create(:district, slug: 'zap')
      create(:user, district: district, email: 'test@example.com')
      data = {
        email: 'test@example.com',
        password: 'secret',
        password_confirmation: 'sorcret',
        digest: 'abc12345' * 8,
        terms_accepted: false
      }

      post api_registrations_url(subdomain: 'zap'), registration: data

      expect(response.status).to be 422
      expect(response_json[:errors]).to eq(
        city: ['blank'],
        digest: ['blank'],
        email: ['taken'],
        name: ['blank'],
        nickname: ['blank'],
        password: ['too_short'],
        password_confirmation: ['confirmation'],
        school: ['blank'],
        state: ['blank'],
        street: ['blank'],
        terms_accepted: ['accepted'],
        zip_code: ['blank']
      )
    end
  end
end

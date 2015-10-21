require 'rails_helper'

describe 'Students API' do
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

  describe 'index action' do
    it 'cannot be accessed without authentication' do
      create(:district, slug: 'qux')

      get api_students_url(subdomain: 'qux'), nil, invalid_auth_headers

      expect(response.status).to be 401
    end

    it 'includes data on students and current bus locations' do
      district = create(:district, slug: 'foo')
      user = create(:user, district: district)
      school = create(:school, district: district)
      label = create(:student_label,
        school: school,
        student: create(:student, district: district),
        user: user,
        nickname: 'First'
      )
      create(:student_label,
        school: school,
        student: create(:student, district: district),
        user: user,
        nickname: 'Second'
      )
      bus = create(:bus, district: district, identifier: 'BUS001')
      6.times do |n|
        create(:bus_location,
          bus: bus,
          recorded_at: Time.zone.local(2015, 1, 1, n)
        )
      end
      create(:bus_assignment, student: label.student, bus: bus)

      get api_students_url(subdomain: 'foo'), nil, auth_headers(user)

      expect(response).to be_successful
      expect(response_json.keys).to match_array [
        :students, :schools, :buses, :bus_locations
      ]
      first_student = response_json[:students].find do |student|
        student[:nickname] == 'First'
      end
      second_student = response_json[:students].find do |student|
        student[:nickname] == 'Second'
      end
      expect(first_student[:bus_id]).to eq bus.id
      expect(first_student[:school_id]).to eq school.id
      expect(second_student[:bus_id]).to eq nil
      expect(response_json[:buses].first[:identifier]).to eq 'BUS001'
      expect(response_json[:buses].first[:bus_location_ids]).to have(5).items
      bus_location = response_json[:bus_locations].first
      expect(bus_location[:recorded_at]).to eq '2015-01-01T05:00:00Z'
    end
  end

  describe 'create action' do
    it 'cannot be accessed without authentication' do
      create(:district, slug: 'qux')

      post api_students_url(subdomain: 'qux'), nil, invalid_auth_headers

      expect(response.status).to be 401
    end

    it 'creates a student label for the current user' do
      district = create(:district, slug: 'foo')
      school = create(:school, district: district)
      user = create(:user, district: district)
      student = create(:student, district: district, digest: '4' * 64)
      bus = create(:bus, district: district, identifier: 'BUS001')
      create(:bus_assignment, student: student, bus: bus)

      payload = {
        student: { digest: '4' * 64, nickname: 'Bobby', school_id: school.id }
      }
      post api_students_url(subdomain: 'foo'), payload, auth_headers(user)

      expect(response).to be_successful
      expect(response_json.keys).to match_array [
        :student, :schools, :buses, :bus_locations
      ]
      expect(response_json[:student][:nickname]).to eq 'Bobby'
      expect(response_json[:student][:school_id]).to eq school.id
      expect(response_json[:student][:bus_id]).to eq bus.id
      expect(StudentLabel.count).to be 1
      expect(user.student_labels.count).to be 1
    end

    it 'returns error information if the input is invalid' do
      district = create(:district, slug: 'foo')
      user = create(:user, district: district)
      create(:student_label,
        school: create(:school, district: district),
        student: create(:student, district: district),
        user: user,
        nickname: 'Dobby'
      )

      payload = { student: { digest: '4' * 64, nickname: 'Dobby' } }
      post api_students_url(subdomain: 'foo'), payload, auth_headers(user)

      expect(response.status).to be 422
      expect(response_json[:errors]).to eq(
        digest: ['blank'],
        nickname: ['taken'],
        school: ['blank']
      )
    end
  end
end

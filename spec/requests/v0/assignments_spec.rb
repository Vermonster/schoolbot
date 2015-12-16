require 'rails_helper'

describe 'v0 assignments API' do
  include ActionController::HttpAuthentication::Basic

  def auth_headers(district)
    basic_auth_token = encode_credentials(district.slug, district.api_secret)
    { 'HTTP_AUTHORIZATION' => basic_auth_token }
  end

  def invalid_auth_headers
    { 'HTTP_AUTHORIZATION' => encode_credentials('invalid!', 'secret') }
  end

  describe 'show endpoint' do
    it 'retrieves a student by digest to allow remote verification' do
      student = create(:student,
        digest: '1' * 64,
        current_bus: create(:bus, identifier: 'ABC')
      )

      get api_v0_assignment_path('1' * 64), nil, auth_headers(student.district)

      expect(response).to be_successful
      expect(response_json).to eq(
        assignment: { sha: '1' * 64, bus_identifier: 'ABC' }
      )
    end

    it 'fails with incorrect credentials' do
      create(:student, digest: '2' * 64)

      get api_v0_assignment_path('2' * 64), nil, invalid_auth_headers

      expect(response.status).to be 401
    end

    it 'fails if the district is inactive' do
      district = create(:district, is_active: false)

      get api_v0_assignment_path('3' * 64), nil, auth_headers(district)

      expect(response.status).to be 401
    end
  end

  describe 'create endpoint' do
    it 'creates or updates student bus assignments' do
      district = create(:district)
      create(:student,
        district: district,
        digest: '1' * 64,
        current_bus: create(:bus, district: district, identifier: 'ABC')
      )
      request_data = {
        assignments: [
          { sha: '1' * 64, bus_identifier: 'DEF' },
          { sha: '2' * 64, bus_identifier: 'ABC' }
        ]
      }

      post api_v0_assignments_path, request_data.as_json, auth_headers(district)

      expect(response.status).to be 202
      expect(Bus.count).to be 2
      expect(Student.count).to be 2
      expect(BusAssignment.count).to be 3
      expect(district.buses.count).to be 2
      expect(district.students.count).to be 2
    end

    it 'fails with incorrect credentials' do
      request_data = { assignments: [] }

      post api_v0_assignments_path, request_data.as_json, invalid_auth_headers

      expect(response.status).to be 401
    end

    it 'fails if the district is inactive' do
      district = create(:district, is_active: false)

      post api_v0_assignments_path, {}, auth_headers(district)

      expect(response.status).to be 401
    end

    it 'fails with an incorrect top-level parameter' do
      district = create(:district)
      request_data = { wrong_key: [{ sha: '1' * 64, bus_identifier: 'ABC' }] }

      post api_v0_assignments_path, request_data.as_json, auth_headers(district)

      expect(response.status).to be 422
      expect(Bus.count).to be 0
      expect(Student.count).to be 0
    end

    it 'fails with an incorrect assignment attribute' do
      district = create(:district)
      request_data = { assignments: [{ sha: '1' * 64, wrong_attr: 'ABC' }] }

      post api_v0_assignments_path, request_data.as_json, auth_headers(district)

      expect(response.status).to be 422
      expect(Bus.count).to be 0
      expect(Student.count).to be 0
    end

    it 'fails if an attribute is a data type other than null or string' do
      district = create(:district)
      request_data = { assignments: [{ sha: '1' * 64, bus_identifier: 123 }] }

      post api_v0_assignments_path, request_data.as_json, auth_headers(district)

      expect(response.status).to be 422
      expect(Bus.count).to be 0
      expect(Student.count).to be 0
    end
  end
end

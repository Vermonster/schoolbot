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

    it 'includes data on students and recent bus locations' do
      district = create(:district, slug: 'foo')
      user = create(:user,
        district: district,
        confirmed_at: Time.zone.local(2015, 10, 1)
      )
      school = create(:school, district: district)
      label = create(:student_label,
        user: user,
        school: school,
        student: create(:student, district: district),
        nickname: 'First'
      )
      create(:student_label,
        user: user,
        school: school,
        student: create(:student, district: district),
        nickname: 'Second'
      )
      bus = create(:bus, district: district, identifier: 'BUS001')
      create(:bus_assignment, student: label.student, bus: bus)
      9.times do |n|
        create(:bus_location,
          bus: bus,
          recorded_at: Time.zone.local(2015, 10, 10, 1, n)
        )
      end

      Timecop.travel(Time.zone.local(2015, 10, 10, 1, 9)) do
        get api_students_url(subdomain: 'foo'), nil, auth_headers(user)
      end

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
      expect(response_json[:buses].first[:bus_location_ids]).to have(4).items
      bus_location = response_json[:bus_locations].first
      expect(bus_location[:recorded_at]).to eq '2015-10-10T01:08:00Z'
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

  describe 'update action' do
    it 'cannot be accessed without authentication' do
      create(:district, slug: 'qux')

      put api_student_url(0, subdomain: 'qux'), nil, invalid_auth_headers

      expect(response.status).to be 401
    end

    it 'cannot update student labels that do not belong to the current user' do
      district = create(:district, slug: 'foo')
      first_user, second_user = create_list(:user, 2, district: district)
      student_label = create(:student_label, user: first_user)

      url = api_student_url(student_label.id, subdomain: 'foo')
      put url, {}, auth_headers(second_user)

      expect(response.status).to be 404
    end

    it 'updates a student label for the current user' do
      district = create(:district, slug: 'foo')
      old_school, new_school = create_list(:school, 2, district: district)
      user = create(:user, district: district)
      student_label = create(:student_label, user: user, school: old_school)

      put(
        api_student_url(student_label.id, subdomain: 'foo'),
        { student: { nickname: 'Jenny', school_id: new_school.id } },
        auth_headers(user)
      )

      expect(response).to be_successful
      student_label.reload
      expect(student_label.nickname).to eq 'Jenny'
      expect(student_label.school).to eq new_school
    end

    it 'returns error information if the input is invalid' do
      district = create(:district, slug: 'baz')
      user = create(:user, district: district)
      school = create(:school, district: district)
      student_label = create(:student_label, user: user)

      put(
        api_student_url(student_label.id, subdomain: 'baz'),
        { student: { nickname: '', school_id: school.id } },
        auth_headers(user)
      )

      expect(response.status).to be 422
      expect(response_json[:errors]).to eq(nickname: ['blank'])
    end
  end
end

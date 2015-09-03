if Rails.env.staging? || Rails.env.development?
  namespace :staging do
    desc 'Seed data for staging environment'
    task reset: :environment do
      district = District.joins(:buses).first
      if district.nil? || district.buses.count < 2
        fail 'Staging reset requires a district with at least 2 buses!'
      end

      puts "Performing reset with district: #{district.slug}"

      district.users.destroy_all
      district.students.destroy_all
      district.schools.destroy_all

      brockton_high = School.create!(
        district: district,
        name: 'Brockton High School',
        address: '470 Forest Avenue, Brockton, MA',
        latitude: 42.070156,
        longitude: -71.039912
      )
      ashfield_middle = School.create!(
        district: district,
        name: 'Ashfield Middle School',
        address: '225 Coe Road, Brockton, MA',
        latitude: 42.103252,
        longitude: -70.997137
      )
      baker_elementary = School.create!(
        district: district,
        name: 'Baker Elementary School',
        address: '45 Quincy Street, Brockton, MA',
        latitude: 42.093800,
        longitude: -70.989331
      )

      user = User.create!(
        district: district,
        email: 'test@example.com',
        password: 'testpass',
        name: 'Test User',
        street: '1 Ash St',
        city: 'West Bridgewater',
        state: 'MA',
        zip_code: '02379',
        latitude: 42.016633,
        longitude: -71.001635
      )

      bobby_label = StudentLabel.create!(
        nickname: 'Bobby',
        user: user,
        school: baker_elementary,
        student: Student.create!(
          district: district,
          digest: Digest::SHA256.hexdigest('a1:jones:2001-01-01')
        )
      )
      jenny_label = StudentLabel.create!(
        nickname: 'Jenny',
        user: user,
        school: brockton_high,
        student: Student.create!(
          district: district,
          digest: Digest::SHA256.hexdigest('a2:jones:2002-02-02')
        )
      )
      davie_label = StudentLabel.create!(
        nickname: 'Davie',
        user: user,
        school: ashfield_middle,
        student: Student.create!(
          district: district,
          digest: Digest::SHA256.hexdigest('a3:jones:2003-03-03')
        )
      )

      locations = district.bus_locations.order(recorded_at: :desc).limit(50)
      buses = Bus.find(locations.pluck(:bus_id).uniq)

      BusAssignment.create!(student: bobby_label.student, bus: buses.first)
      BusAssignment.create!(student: jenny_label.student, bus: buses.second)
      BusAssignment.create!(student: davie_label.student, bus: buses.first)

      free_student_1 = Student.create!(
        district: district,
        digest: Digest::SHA256.hexdigest('b1:smith:2001-01-01')
      )
      free_student_2 = Student.create!(
        district: district,
        digest: Digest::SHA256.hexdigest('b2:smith:2002-02-02')
      )

      BusAssignment.create!(student: free_student_1, bus: buses.second)
      BusAssignment.create!(student: free_student_2, bus: buses.third)
    end
  end
end

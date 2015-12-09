if Rails.env.staging? || Rails.env.development?
  namespace :staging do
    desc 'Reset fake staging user and students for all districts'
    task reset: :environment do
      District.find_each do |district|
        if district.buses.count >= 3 && district.schools.count >= 3
          puts "Resetting: #{district.slug}"

          district.users.destroy_all
          district.students.destroy_all

          school_for_geocode = district.schools.last
          user = User.create!(
            district: district,
            email: 'test@example.com',
            password: 'testpass',
            name: 'Test User',
            street: '1 Main St',
            city: 'Anytown',
            state: 'USA',
            zip_code: '12345',
            latitude: school_for_geocode.latitude,
            longitude: school_for_geocode.longitude,
            confirmed_at: Time.current
          )

          bobby_label = StudentLabel.create!(
            nickname: 'Bobby',
            user: user,
            school: district.schools.first,
            student: Student.create!(
              district: district,
              digest: Digest::SHA256.hexdigest('a1:jones:2001-01-01')
            )
          )
          jenny_label = StudentLabel.create!(
            nickname: 'Jenny',
            user: user,
            school: district.schools.second,
            student: Student.create!(
              district: district,
              digest: Digest::SHA256.hexdigest('a2:jones:2002-02-02')
            )
          )
          StudentLabel.create!(
            nickname: 'Danny',
            user: user,
            school: district.schools.third,
            student: Student.create!(
              district: district,
              digest: Digest::SHA256.hexdigest('a3:jones:2003-03-03')
            )
          )

          locations = district.bus_locations.order(recorded_at: :desc).limit(50)
          buses = Bus.find(locations.pluck(:bus_id).uniq)

          BusAssignment.create!(student: bobby_label.student, bus: buses.first)
          BusAssignment.create!(student: jenny_label.student, bus: buses.second)

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
        else
          puts "Skipping: #{district.slug}"
        end
      end
    end
  end
end

if Rails.env.development? || Rails.env.test?
  require "factory_girl"

  namespace :dev do
    desc "Seed data for development environment"
    task prime: "db:setup" do
      include FactoryGirl::Syntax::Methods

      brockton = create(:district,
        slug: 'brockton',
        name: 'Brockton Public Schools'
      )

      brockton_high = create(:school,
        district: brockton,
        name: 'Brockton High School',
        address: '470 Forest Avenue, Brockton, MA',
        latitude: 42.070156,
        longitude: -71.039912
      )
      ashfield_middle = create(:school,
        district: brockton,
        name: 'Ashfield Middle School',
        address: '225 Coe Road, Brockton, MA',
        latitude: 42.103252,
        longitude: -70.997137
      )
      baker_elementary = create(:school,
        district: brockton,
        name: 'Baker Elementary School',
        address: '45 Quincy Street, Brockton, MA',
        latitude: 42.093800,
        longitude: -70.989331
      )

      user = create(:user,
        district: brockton,
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
      create(:user, :unconfirmed,
        district: brockton,
        confirmation_token: '12345',
        latitude: 42.016633,
        longitude: -71.001635
      )

      bobby_label = create(:student_label,
        nickname: 'Bobby',
        user: user,
        school: baker_elementary,
        student: create(:student, district: brockton)
      )
      jenny_label = create(:student_label,
        nickname: 'Jenny',
        user: user,
        school: brockton_high,
        student: create(:student, district: brockton)
      )
      create(:student_label,
        nickname: 'Davie',
        user: user,
        school: ashfield_middle,
        student: create(:student, district: brockton)
      )

      bus1 = create(:bus, district: brockton, identifier: 'BUS001')
      bus2 = create(:bus, district: brockton, identifier: 'BUS002')

      10.times do |n|
        create(:bus_location, bus: bus1, recorded_at: n.minutes.ago)
      end
      10.times do |n|
        create(:bus_location, bus: bus2, recorded_at: n.minutes.ago)
      end

      create(:bus_assignment, student: bobby_label.student, bus: bus1)
      create(:bus_assignment, student: jenny_label.student, bus: bus2)

      not_added_student = create(:student,
        district: brockton,
        digest: Digest::SHA256.hexdigest('abc123:smith:2000-01-01')
      )
      create(:bus_assignment, student: not_added_student, bus: bus1)
    end
  end
end

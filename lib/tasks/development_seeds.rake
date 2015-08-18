if Rails.env.development? || Rails.env.test?
  require "factory_girl"

  namespace :dev do
    desc "Seed data for development environment"
    task prime: "db:setup" do
      include FactoryGirl::Syntax::Methods

      boston = create(:district, name: 'Boston Public Schools', slug: 'boston')
      brockton = create(:district, name: 'Brockton Schools', slug: 'brockton')

      adams_elementary = create(:school,
        district: boston,
        name: 'Samuel Adams Elementary',
        address: '165 East Webster St, East Boston, MA',
        latitude: 42.365727789474,
        longitude: -71.034763052632
      )
      burke_high = create(:school,
        district: boston,
        name: 'Jeremiah E. Burke High',
        address: '60 Washington St, Dorchester, MA',
        latitude: 42.246033,
        longitude: -71.1199965
      )
      create(:school,
        district: brockton,
        name: 'Brockton High School',
        address: '470 Forest Avenue, Brockton, MA',
        latitude: 42.070156,
        longitude: -71.039912
      )

      user = create(:user,
        district: boston,
        email: 'test@test.com',
        password: 'testtest',
        name: 'Test User',
        street: '75 Broad St',
        city: 'Boston',
        state: 'MA',
        zip_code: '02109',
        latitude: 42.357859,
        longitude: -71.053574
      )

      bobby_label = create(:student_label,
        nickname: 'Bobby',
        user: user,
        school: adams_elementary,
        student: create(:student, district: boston)
      )
      jenny_label = create(:student_label,
        nickname: 'Jenny',
        user: user,
        school: burke_high,
        student: create(:student, district: boston)
      )
      create(:student_label,
        nickname: 'Davie',
        user: user,
        school: adams_elementary,
        student: create(:student, district: boston)
      )

      bus1 = create(:bus, district: boston, identifier: 'BUS001')
      bus2 = create(:bus, district: boston, identifier: 'BUS002')

      10.times do |n|
        create(:bus_location, bus: bus1, recorded_at: n.minutes.ago)
      end
      10.times do |n|
        create(:bus_location, bus: bus2, recorded_at: n.minutes.ago)
      end

      create(:bus_assignment, student: bobby_label.student, bus: bus1)
      create(:bus_assignment, student: jenny_label.student, bus: bus2)
    end
  end
end

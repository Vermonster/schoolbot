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
        password: 'testtest'
      )

      create(:student_label,
        nickname: 'Bobby',
        user: user,
        school: adams_elementary,
        student: create(:student, district: boston)
      )
      create(:student_label,
        nickname: 'Jenny',
        user: user,
        school: burke_high,
        student: create(:student, district: boston)
      )
    end
  end
end

FactoryGirl.define do
  factory :district do
    sequence(:name) { |n| "Test District #{n}" }
    sequence(:slug) { |n| "district#{n}" }
    sequence(:contact_phone) { |n| "555-000#{n}" }
    sequence(:contact_email) { |n| "contact@district#{n}.example.org" }
    sequence(:zonar_customer) { |n| "abc000#{n}" }
    zonar_username "TestUsername"
    zonar_password "TestPassword"
  end

  factory :school do
    district
    sequence(:name) { |n| "Test School #{n}" }
    sequence(:address) { |n| "#{n} School St, Anytown, USA" }
  end

  factory :student do
    district
    sequence(:digest) { |n| "student-digest-#{n}" }
  end

  factory :student_label do
    school
    student
    user
    sequence(:nickname) { |n| "Nickname #{n}" }
  end

  factory :user do
    district
    sequence(:email) { |n| "user#{n}@example.org" }
    password "TestPassword"
  end
end

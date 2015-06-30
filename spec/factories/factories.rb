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
end

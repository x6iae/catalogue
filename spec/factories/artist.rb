FactoryGirl.define do
  factory :artist do
    email     { Faker::Internet.email }
    password  { Faker::Internet.password }
  end
end

FactoryGirl.define do
  factory :customer do

    # TODO add additional validations

    uuid { Faker::Base.bothify("?#?#?##") }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
  end
end

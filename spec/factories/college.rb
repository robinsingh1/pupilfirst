FactoryGirl.define do
  factory :college do
    name { Faker::Lorem.words(3).join(' ') }
    city { Faker::Address.city }
    state

    after(:build) do |college|
      # Use the same state as college.
      college.replacement_university = create(:replacement_university, state: college.state)
    end
  end
end

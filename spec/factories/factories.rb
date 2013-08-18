FactoryGirl.define do
  factory :user, :aliases => [:giver, :receiver, :claimer] do
    name  { Faker::Name.name }
    email { Faker::Internet.free_email }
    password 'pizza'
    password_confirmation 'pizza'
    github_token { Faker::Lorem.characters(15) }

    association :cohort, :strategy => :build

    factory(:admin_user)   { roles ['admin'] }
    factory(:student_user) { roles ['student'] }
  end

  factory :cohort do
    sequence(:name) { |n| "Summer #{n}" }
    in_session true
    start_date Date.today
    location "San Francisco"
  end

  factory :api_key do
    user_id 1
    key "test_access1"
  end
end

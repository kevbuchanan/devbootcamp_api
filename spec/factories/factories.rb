FactoryGirl.define do
  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.free_email }
    password 'pizza'
    password_confirmation 'pizza'
    github_token { Faker::Lorem.characters(15) }

    association :cohort, :strategy => :build
    association :api_key, :strategy => :create
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
    user_id 5
    key { SecureRandom.hex}
  end

  factory :challenge do
    actor_id 1
    challenge_unit_id 1
    level '1'
    sequence(:name) { |n| "Ruby Challenge #{n}" }
    description 'prime factors'
    source_repo 'http://github.com/example'
  end

  factory :unpublished_challenge, class: Challenge do
    actor_id 1
    challenge_unit_id 1
    level '1'
    sequence(:name) { |n| "Unpublished Ruby Challenge #{n}" }
    description 'prime factors'
    source_repo 'http://github.com/example'
    draft true
  end

  factory :challenge_attempt do
    state 'finished'
    challenge_id 1
    actor_id 1
    repo 'http://github.com/example'
  end

  factory :exercise do
    intro 'test intro'
    title 'test title'
    sequence(:slug) { |n| "slug#{n}" }
    state  'published'
  end

  factory :unpublished_exercise, class: Exercise do
    intro 'test intro'
    title 'test title'
    sequence(:slug) { |n| "slug#{n}" }
    state  'unpublished'
  end

  factory :exercise_attempt do
    exercise_id 1
    code 'test code'
    results 'test results'
    actor_id 1
  end
end

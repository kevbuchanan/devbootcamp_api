class Actor < ActiveRecord::Base
  has_many :exercises
  has_many :exercise_attempts
  has_many :challenges
  has_many :challenge_attempts
  has_many :actor_users, :dependent => :destroy
  has_many :users, through: :actor_users
end

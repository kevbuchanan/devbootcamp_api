class User < ActiveRecord::Base
  include User::Profile

  attr_accessible :name, :password, :password_confirmation, :cohort, :roles, :email
  attr_accessible :github, :quora, :twitter, :facebook, :linked_in, :blog, :hacker_news

  has_secure_password

  has_one  :api_key
  delegate :key, :to => :api_key
  belongs_to :cohort
  has_many :exercise_attempts
  has_many :actor_users
  has_many :actors, through: :actor_users
  has_many :challenge_attempts, :through => :actors, :uniq => true
  has_many :exercise_attempts, :through => :actors

  def active_model_serializer
    V1::UserSerializer
  end
end

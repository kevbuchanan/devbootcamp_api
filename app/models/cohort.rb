class Cohort < ActiveRecord::Base

  LOCATIONS = ["San Francisco", "Chicago"]

  attr_accessible :name, :location

  has_many :users
  has_many :challenge_attempts

  scope :in_session, where(:in_session => true)
  
  def active_model_serializer
    V1::CohortSerializer
  end
end

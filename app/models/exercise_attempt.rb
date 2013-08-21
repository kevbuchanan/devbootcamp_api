class ExerciseAttempt < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :actor

  scope :correct,   where(:correct => true)
  scope :incorrect, where(:correct => false)

  def active_model_serializer
    V1::ExerciseAttemptSerializer
  end
end

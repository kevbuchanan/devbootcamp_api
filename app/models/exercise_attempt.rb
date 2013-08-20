class ExerciseAttempt < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :actor

  scope :correct,   where(:correct => true)
  scope :incorrect, where(:correct => false)

  def active_model_serializer
    V1::ExerciseAttemptSerializer
  end

  def self.latest_correct_timestamp
    self.correct.maximum(:created_at)
  end

  def results
    # Display output messages first
    Array(self[:results]).sort_by { |res| res['message_type'] == 'output' ? 0 : 1}
  end

  private

  def evaluate_code
    self.correct = self.exercise.correct?(self.code)
    self.results = self.exercise.results(self.code)
  end

  def notify_correct_attempts
    if self.correct?
      notify_observers(:correct_attempt)
    end
  end

  def touch_exercise_if_correct
    self.exercise.touch if self.correct?
  end
end

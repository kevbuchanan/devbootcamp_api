class ChallengeAttempt < ActiveRecord::Base
  belongs_to :challenge

  scope :by_recency, order(:created_at).reverse_order
  scope :by_date, lambda { |date| where(:created_at => date.beginning_of_day..date.end_of_day) }

  def active_model_serializer
    V1::ChallengeAttemptSerializer
  end
end

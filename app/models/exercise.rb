class Exercise < ActiveRecord::Base

  scope :published, where(:state => :published)

  scope :by_recency, order(:published_at).reverse_order

  def active_model_serializer
    V1::ExerciseSerializer
  end
end

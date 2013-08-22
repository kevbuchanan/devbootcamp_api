class Exercise < ActiveRecord::Base
  belongs_to :actor
  has_many :attempts, :class_name => 'ExerciseAttempt', :dependent => :destroy

  scope :published, where(:state => :published)

  scope :by_recency, order(:published_at).reverse_order

  def active_model_serializer
    V1::ExerciseSerializer
  end
end

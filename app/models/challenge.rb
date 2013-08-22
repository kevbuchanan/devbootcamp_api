class Challenge < ActiveRecord::Base
  scope :published, where(:draft => false)

  def active_model_serializer
    V1::ChallengeSerializer
  end
end

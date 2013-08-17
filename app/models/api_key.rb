class ApiKey < ActiveRecord::Base
  before_create :generate_access_token
  belongs_to :user
  validates_uniqueness_of :key
  validates_presence_of   :key, :user_id

  private

  def generate_access_token
    begin
      self.key = SecureRandom.hex
    end while self.class.exists?(key: key)
  end
end
class Cohort < ActiveRecord::Base

  LOCATIONS = ["San Francisco", "Chicago"]

  has_many :users
  has_many :challenge_attempts

  scope :in_session, where(:in_session => true)
  scope :next, lambda { |c| where(["cohorts.id > ?", c.id]).order("id ASC") }
  scope :prev, lambda { |c| where(["cohorts.id < ?", c.id]).order("id DESC") }
  scope :visible, where(:visible => true)

  def active_model_serializer
    V1::CohortSerializer
  end

  def self.current_students
    User.joins(:cohort).where(:cohorts => {:in_session => true}).by_name
  end

  def nickname
    self.name.gsub(/\d/, '').strip.split(' ').last
  end

  def boots
    users.reject(&:instructor?)
  end

  def week
    Date.today.cweek - self.start_date.cweek + 1
  end

  # the time since starting / phase size rounded up
  def phase
    case
    when prep?
      "Prep"
    when phase_one?
      "Phase 1"
    when phase_two?
      "Phase 2"
    when phase_three?
      "Phase 3"
    when alumni?
      "Alumni"
    end
  end

  def prep?
    (Date.today >= (self.start_date - 9.weeks)) && (Date.today < self.start_date)
  end

  def phase_one?
    Date.today.between?(self.start_date, self.start_date + 3.weeks)
  end

  def phase_two?
    Date.today.between?(self.start_date + 3.weeks, self.start_date + 6.weeks)
  end

  def phase_three?
    Date.today.between?(self.start_date + 6.weeks, self.start_date + 9.weeks)
  end

  def alumni?
    self.start_date + 9.weeks <= Date.today
  end

  def sf?
    location == "San Francisco"
  end

  protected

  def generate_slug
    self.slug = name.parameterize
  end
end

class ChallengeAttempt < ActiveRecord::Base
  belongs_to :actor
  belongs_to :challenge

  scope :by_actor, lambda { |actor| where(:actor_id => actor.id) }
  scope :by_either_user_in, lambda { |actor| includes(:actor => :users).where(["users.id in (?)", actor.user_ids]) }
  scope :by_recency, order(:created_at).reverse_order
  scope :by_date, lambda { |date| where(:created_at => date.beginning_of_day..date.end_of_day) }
  scope :within_a_day_around, lambda { |date| where(:created_at => (date-12.hours)..(date+12.hours)) }

  def active_model_serializer
    V1::ChallengeAttemptSerializer
  end

  # Returns the most recent ChallengeAttempt for the given +actor+.  Most useful when used as a scope and a Challenge.
  def self.latest_attempt_for(actor)
    by_actor(actor).by_recency.first
  end

  def users #:nodoc:
    self.actor.users
  end

  # Returns +true+ if this ChallengeAttempt has not yet been started
  def unstarted?
    self.new_record? || self.state.nil?
  end

  # Returns +true+ if the student has indicted they're "done," regardless of pass/fail state
  def finished?
    finished_at?
  end

  def submit_time
    if finished?
      finished_at - created_at
    else
      nil
    end
  end

  def can_submit?
    !unstarted? && !submitted?
  end

  private

  def initialize_state
    start(false) if state.blank?
  end

  def set_cohort_id
    self.cohort_id = self.actor.cohort_id
  end

  def create_repo
    update_column(:repo, GithubUtility.create_repo(actor, challenge))
  end
end
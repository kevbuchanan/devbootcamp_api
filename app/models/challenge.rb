class Challenge < ActiveRecord::Base
  belongs_to :actor

  belongs_to :unit,
             :class_name  => 'ChallengeUnit',
             :foreign_key => :challenge_unit_id,
             :autosave => true

  belongs_to :prerequisite,
             :class_name => 'Challenge'

  has_many :attempts,
           :class_name => 'ChallengeAttempt',
           :dependent  => :destroy

  has_many :submitted_attempts,
           :class_name => 'ChallengeAttempt',
           :conditions => {:state => 'submitted'}

  has_many :submitted_actors,
           :class_name => 'Actor',
           :through    => :submitted_attempts,
           :source     => :actor,
           :uniq       => true

  has_many :submitted_users,
           :class_name => 'User',
           :through    => :submitted_actors,
           :source     => :users,
           :uniq       => true

  scope :required, where(:required => true)
  scope :optional, where(:required => false)
  scope :published, where(:draft => false)
  scope :unpublished, where(:draft => true)

  def active_model_serializer
    V1::ChallengeSerializer
  end

  # Returns +true+ if +actor+ can start this Challenge and +false+ otherwise
  def startable_by?(actor)
    self.published? # && self.unit.available_to?(actor)
  end
  alias :available_to? :startable_by? # To allow duck typing with ChallengeUnit

  # Creates a new ChallengeAttempt associated with the given +actor+.
  def start!(actor)
    self.attempts.create!(:actor => actor)
  end

  # Returns the most recent ChallengeAttempt against this Challenge for the given +actor+
  def latest_attempt_for(actor)
    self.attempts.latest_attempt_for(actor)
  end

  # Returns the most recent started ChallengeAttempt against this Challenge for the given +actor+
  def latest_started_attempt_for(actor)
    self.attempts.started.latest_attempt_for(actor)
  end

  # Returns the latest started ChallengeAttempt for the given +actor+ if it exists, otherwise returns a new ChallengeAttempt
  def find_or_build_latest_attempt_for(actor)
    self.latest_started_attempt_for(actor) || self.attempts.build(:actor_id => actor.id)
  end

  # NOTE
  # startable_by? logic has to live here, but started_by? logic
  # more properly live in Actor.  We could define Actor#can_start? which calls
  # Challenge#startable_by? and then move these two methods to Actor.
  # -jfarmer

  # Returns +true+ if +actor+ has started (and NOT submitted) this Challenge and +false+ otherwise
  def started_by?(actor_or_user)
    actor_or_user.started_challenge_ids.include?(self.id)
  end

  def submitted_by?(actor_or_user)
    actor_or_user.submitted_challenge_ids.include?(self.id)
  end

  def gist?
    source_repo =~ /gist.github.com/
  end

  def gist_id
    return nil unless gist?
    source_repo[/\/([\d|a-z|A-Z]*)$/, 1]
  end

  def repo?
    return false if source_repo.blank?
    !gist?
  end

  def repo_user_name
    return nil unless repo?
    source_repo.partition("github.com/")[2].split('/')[0]
  end

  def repo_repo_name
    return nil unless repo?
    source_repo.partition("github.com/")[2].split('/')[1].chomp(".git")
  end

  def published?
    !draft
  end

  # Why does't acts_as_commentable expose a #comments association on this class?
  def comments_count
    Comment.where(:commentable_type => self.class, :commentable_id => self.id).count
  end

  private

  def set_published_state
    self.draft = !actor.admin?
    true
  end

  def send_email_diff
    if self.description_changed?
      # We include the version id to guard against race conditions
      # challenge.versions.latest might be out of sync
      ChallengesMailer.delay.challenge_updated(self.id, self.versions.last.id)
    end
  end
end

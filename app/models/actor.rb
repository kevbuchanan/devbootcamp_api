# An Actor could represent a single user or a group of users (a pair or more).
# A single user or a group of use can 'act' on specific actions such as exercise attempts.
# It's important to know:
#   - Once an actor is created it can not be altered. The only attribute that's accessible is name.
#     When users are added to an actor, you can't edit, replace or remove them.
#   - The same group of users can't be presented by different actors. So the users attribute is unique.
#   - There is only one way to add users to an actor, using the accessor method users=, anything else will
#     throw an exception.
#   - Name (unless given) and users_count will be set automatically based on the users.
#   - You can't create an actor without users.
class Actor < ActiveRecord::Base
  attr_accessible :name
  attr_protected :users, :users_count

  has_many :exercises
  has_many :exercise_attempts

  # We have a CorrectExerciseAttempt class, but it's used to make user-centric
  # queries faster, so it has a user_id foreign key
  # has_many :correct_exercise_attempts,
  #          :conditions => ExerciseAttempt.correct.where_values_hash,
  #          :class_name => 'ExerciseAttempt',
  #          :order => 'created_at ASC'

  # has_many :solved_exercises,
  #          :through => :correct_exercise_attempts,
  #          :source => :exercise,
  #          :uniq => true

  has_many :challenges
  has_many :challenge_attempts

  has_many :actor_users, :dependent => :destroy
  has_many :users, through: :actor_users do
    # We only allow adding users with the users setter.
    # This prevents adding users to an existing actor.
    def << users
      transaction do
        raise(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  has_many :session_logs

  has_many :related_actors,
           :class_name => 'Actor',
           :through => :users,
           :source  => :actors,
           :uniq => true

  [:started, :submitted].each do |state|
    has_many :"#{state}_challenge_attempts",
                       :class_name => 'ChallengeAttempt',
                       :conditions => {:state => state}
    has_many :"#{state}_challenges",
                       :through => :"#{state}_challenge_attempts",
                       :source  => :challenge,
                       :uniq    => true
  end

  default_scope includes(:users)

  # There is probably a cleaner and more effecient way to do this, for now this works.
  def self.find_by_users users
    return if users.blank?
    user_ids = users.map(&:id)

    where(:users => {:id => users}, :users_count => users.size).
      includes(:users).
      find { |actor| actor.user_ids.sort == user_ids }
  end

  def self.find_or_create_by_users users
    actor = self.find_by_users users
    actor = self.create_by_users(users) if actor.blank?
    actor
  end

  def self.create_by_users users
    return if users.blank?
    actor = self.new
    actor.users = users
    actor.save
    actor
  end

  def users=(users)
    transaction do
      # Only allow users to be set once. If we try to set the users again,
      # then we raise an error
      self.users.present? ? raise("Users are Immutable") : super(users)
    end
  end

  # Only allow adding users with the users setter.
  # This prevents adding users to an existing actor.
  def update_attribute attribute, value
    raise(ActiveModel::MassAssignmentSecurity::Error)
  end

  def started?(challenge)
    self.started_challenges.include?(challenge)
  end

  def submitted?(challenge)
    self.submitted_challenges.include?(challenge)
  end

  def solved?(exercise)
    self.solved_exercises.include?(exercise)
  end

  def unsolved_exercise_count
    Exercise.where(:kind => 'exercise').count - self.solved_exercises.length
  end

  def solo?
    self.size == 1
  end

  def pair?
    !solo?
  end

  def solo_user
    if solo?
      @user ||= users.first
    else
      raise "ambiguous user for actor"
    end
  end

  def size
    self.users_count
  end

  # Code is committed as this user when they are both logged in
  def committer
    users.order(:created_at).first
  end

  def github_authorized?
    users.all? { |u| u.github_token.present? }
  end

  def has_roles?
    users.any?(&:has_roles?)
  end

  # just alias for admin for now
  def instructor?
    admin?
  end

  # Admin is only possible if you are solo
  def admin?
    if solo?
      users.first.admin?
    else
      false
    end
  end

  def student?
    users.with_role('student').any?
  end

  def editor?
    users.with_role('editor').any?
  end

  def cohort
    users.first.cohort
  end

  def user_challenge_state_for(user, challenge)
    User::ChallengeState.find_by(user, challenge)
  end

  def get_challenge_state(challenge)
    User::ChallengeState.find_by(users, challenge)
  end

  def get_unit_state(unit)
    User::UnitState.find_by(users, unit)
  end

  def active_model_serializer
    Api::V1::ActorSerializer
  end

  def as_json(options={})
    active_model_serializer.new(self).as_json(options)
  end

  def names
    self.users.map{|user| user.shortened_name }.join(" & ")
  end

  def first_names
    self.users.map{|user| user.first_name }.join(" & ")
  end

  # manually use sunion bc redis-object is trying to use zunion?
  def notifications
    sets = self.users.map { |user| user.notification_ids.key }
    $redis.zunionstore "tmp-#{self.id}", sets
    union = $redis.zrevrangebyscore "tmp-#{self.id}", Time.now.to_i, 1.day.ago.to_i
    $redis.del "tmp-#{self.id}"
    union.map { |id| Notification.find(id) }
  end

  def pusher_channel
    "actor-#{self.id}"
  end

  private

  # Set the name to the last_names of all the users if no name is given.
  # We also want to cache the users size in the users_count column.
  def set_name_and_count
    # why not? ids.sort.join("-")
    self.name = self.users.map(&:last_name).sort.join("-") if self.name.blank?
    self.users_count = self.users.count
    self.cohort_id = self.users.first.cohort_id
  end

  def unique_users
    errors.add(:users, "can't belong to different Actor") if Actor.find_by_users(self.users).present?
  end
end

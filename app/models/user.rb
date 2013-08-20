class User < ActiveRecord::Base
  include User::Profile
  
  attr_accessible :name, :password, :password_confirmation, :cohort, :roles, :email
  attr_accessible :github, :quora, :twitter, :facebook, :linked_in, :blog, :hacker_news
  
  has_secure_password

  has_many :actor_users
  has_many :actors, through: :actor_users
  has_many :challenge_attempts, :through => :actors, :uniq => true
  has_many :feedback_given, :class_name => 'Feedback', :foreign_key => 'giver_id'
  has_many :feedback_receivable, :class_name => 'Feedback', :foreign_key => 'receiver_id'
  has_many :feedback_ratings
  has_one  :api_key
  delegate :key, :to => :api_key

  has_many :comments, :as => :commentable

  has_many :exercise_attempts, :through => :actors

  has_many :correct_exercise_attempts
  has_many :solved_exercises,
           :class_name  => 'Exercise',
           :through     => :correct_exercise_attempts,
           :foreign_key => :exercise_id,
           :source      => :exercise

  [:started, :submitted].each do |state|
    has_many :"#{state}_challenges",         :through => :actors, :uniq    => true
    has_many :"#{state}_challenge_attempts", :through => :actors, :uniq    => true
  end

  # FIXME It's not great to hard code this at the model level -jfarmer
  has_many :exercises, :through => :actors
  has_many :user_tasks
  has_many :completed_tasks, :through => :user_tasks, :source => :task
  has_one  :note, :class_name => 'User::Note'

  belongs_to :cohort

  scope :by_name, order("name ASC")
  scope :staff, where(:roles_mask => [2,4])
  scope :enabled, where('disabled_at IS NULL')

  before_validation :normalize_email

  # only add new roles at the end of the array
  ROLES = %w( student editor admin ta)

  def active_model_serializer
    V1::UserSerializer
  end

  def self.in_session
    User.joins(:cohort).where(:cohorts => {:in_session => true})
  end

  def self.with_role(role)
    # some bitwise math going on here.
    # 001 is the 'student' role, 1 in decimal or 2**0
    # 010 is the 'editor' role, 2 in decimal or 2**1
    # 100 is the 'admin' role, 4 in decimal or 2**2
    # so a user whose role_mask = 7 would look like 111 in binary
    # which is to say they have all 3 roles
    # more here:  http://en.wikipedia.org/wiki/Mask_%28computing%29
    where("roles_mask & #{2**ROLES.index(role.to_s)} > 0")
  end

  def self.find_by_emails_or_names emails_or_names
    where ["email in (?) or name in (?)", emails_or_names, emails_or_names]
  end

  def note
    super || self.note = User::Note.new
  end

  def actor
    Actor.find_or_create_by_users [self]
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def admin?
    has_role?('admin')
  end

  def instructor?
    admin?
  end

  def student?
    has_role?('student')
  end

  def editor?
    has_role?('editor')
  end

  def has_role?(role)
    roles.include?(role)
  end

  def has_roles?
    roles.any?
  end

  def disabled
    !self.disabled_at.nil?
  end
  alias :disabled? :disabled

  def disabled=(disabled)
    if disabled == '0' || !disabled
      self.disabled_at = nil
    elsif !self.disabled?
      self.disabled_at = Time.zone.now
    end
  end

  # add a column on feedback for feedback ratings to optimize #next_feedback_to_rate
  def all_feedback_to_rate
    Feedback.includes(:feedback_ratings).not_involving(self).unrated_by(self).published
  end

  def next_feedback_to_rate
    # We want people to rate the least-rated feedback first
    feedback_pool = all_feedback_to_rate.inject(Hash.new { |h,k| h[k] = []}) do |counts, feedback|
                      counts[feedback.feedback_ratings.size] << feedback
                      counts
                    end

    feedback_pool[feedback_pool.keys.min].sample
  end

  def submitted?(challenge)
    self.submitted_challenges.to_a.include?(challenge)
  end

  def solved?(exercise)
    # ActiveRecord want to be smart.
    # include? on a relation (even w/ .all) adds an extra
    # predicate to the query
    self.solved_exercises.to_a.include?(exercise)
  end

  def unsolved_exercise_count
    Exercise.count - self.solved_exercises.all.length
  end

  def outstanding_tasks
    if completed_task_ids.any?
      # Otherwise you get: SELECT "tasks".* FROM "tasks" WHERE (id NOT in (NULL)) ORDER BY position
      Task.where(["id NOT in (?)", completed_task_ids])
    else
      Task.scoped
    end
  end

  def user_names
    name
  end

  def solo?
    true
  end

  def users
    [ self ]
  end

  def first_name
    self.name.split(' ').first.capitalize
  end

  def last_name
    self.name.split(' ').last
  end

  def shortened_name
    "#{first_name} #{last_name[0]}."
  end

  def given_metafeedback_within?(time)
    self.feedback_ratings.where("created_at >= ? ", time.ago).exists?
  end

  def emailed_within?(time)
    self.has_been_emailed? && self.last_emailed_at >= time.ago
  end

  def has_been_emailed?
    self.last_emailed_at?
  end

  def needs_reminder?(time)
    return false if all_feedback_to_rate.empty?

    if self.has_been_emailed?
      !self.given_metafeedback_within?(time) && !self.emailed_within?(time)
    else
      !self.given_metafeedback_within?(time)
    end
  end

  def emailed!
    update_attributes(:last_emailed_at => Time.zone.now)
  end

  def generate_password!
    self.password = SecureRandom.base64(12)
    self.password_confirmation = password
  end

  def self.staff
    self.with_role("admin")
  end

  def send_password_reset
    generate_password_reset_token
    save!
    UsersMailer.delay_for(5.seconds).password_reset(self.id)
  end

  def send_welcome
    generate_password_reset_token #  required for welcome email
    save!
    UsersMailer.delay_for(5.seconds).welcome(self.id)
  end

  def generate_password_reset_token
    begin
      self.password_reset_token = SecureRandom.urlsafe_base64
    end while User.exists?(:password_reset_token => self.password_reset_token)
    self.password_reset_sent_at = Time.zone.now
  end

  def deleted?
    !!deleted_at
  end

  private

  def normalize_email
    if email_changed? && email.present?
      self.email = self.email.downcase.strip
    end
  end
end

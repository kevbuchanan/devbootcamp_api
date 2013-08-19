class Exercise < ActiveRecord::Base
  belongs_to :actor

  has_many :attempts, :class_name => 'ExerciseAttempt', :dependent => :destroy

  has_many :correct_exercise_attempts, :dependent => :destroy
  has_many :solvers, :class_name  => 'User',
                     :through     => :correct_exercise_attempts,
                     :foreign_key => :user_id,
                     :source      => :user,
                     :uniq        => true

  has_many :solutions, :class_name  => 'ExerciseAttempt',
                       :through     => :correct_exercise_attempts,
                       :foreign_key => :exercise_attempt_id,
                       :source      => :exercise_attempt

  has_many :completed_attempts,
           :class_name => 'ExerciseAttempt',
           :conditions => {:correct => true}

  has_many :completed_actors,
           :class_name => 'Actor',
           :through    => :completed_attempts,
           :source     => :actor,
           :uniq       => true

  scope :published, where(:state => :published)

  scope :by_recency, order(:published_at).reverse_order

  def active_model_serializer
    V1::ExerciseSerializer
  end

  class << self
    # Returns a list of valid Exercise states
    def state_names
      self.state_machine.states.map(&:name).map(&:to_s)
    end

    # This dynamically created initial_code_label, validator_code_label, etc.
    # getters and setters, so subclasses can change "Validator Code" to
    # something more specific like "RSpec", "Jasmine Spec," etc.
    Exercise.columns.select { |col| col.name =~ /_code$/ }.each do |column|
      label_name = "#{column.name}_label"

      attr_writer label_name

      define_method(label_name) do
        instance_variable_get("@#{label_name}") || column.name.titlecase
      end
    end

    # This is here for routing purposes, e.g.,
    # exercise = RubyExercise.find(10)
    # url_for(exercise) # => "/exercises/10"
    # vs.
    # url_for(exercise) # => "/ruby_exercises/10"
    #
    # See http://code.alexreisner.com/articles/single-table-inheritance-in-rails.html
    def inherited(klass) #:nodoc:
      klass.instance_eval do
        def model_name #:nodoc:
          Exercise.model_name
        end
      end

      super
    end
  end

  # Delegate the label helpers to the class-level methods
  Exercise.columns.select { |col| col.name =~ /_code$/ }.each do |column|
    delegate "#{column.name}_label", :to => 'self.class'
  end

  # In the subclass, returns true if the supplied +code+ is correct.
  # Meant to be re-defined by subclasses.  Raises a NotImplemented error.
  def correct?(code)
    raise NotImplementedError, "#{self.class}#correct? is not implemented"
  end

  def completed_by?(actor)
    self.completed_actors.include?(actor)
  end

  def solvers_by_cohort(cohort)
    # We're assuming solvers has been eager-loaded
    self.solvers.where(:cohort_id => cohort)
  end

  # Wrap code in this exercise's wrapper.
  # The default wrapper is <code><%= user_code %></code>
  def wrapped_code(code = self.initial_code)
    wrapper_code? ? wrap_code(code) : code
  end

  private
  def wrap_code(code)
    Erubis::Eruby.new(wrapper_code).result(:user_code => code)
  end

  def set_published_at!
    self.published_at = Time.now
  end
end
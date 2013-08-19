class V1::UserSerializer < V1::BaseSerializer
  attributes :name, :email, :bio, :profile, :cohort_id

  def exercises
    {exercises: object.actor.exercises, exercise_attempts: object.actor.exercise_attempts,
     correct_exercise_attempts: object.actor.correct_exercise_attempts}
  end

  def challenges
    {challenges: object.actor.challenges, challenge_attempts: object.actor.challenge_attempts}
  end
end

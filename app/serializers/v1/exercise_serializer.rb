class V1::ExerciseSerializer < V1::BaseSerializer
  attributes :id, :initial_code, :validator_code, :hint, :solution, :intro, :wrapper_code, :title
end

class V1::UserSerializer < V1::BaseSerializer
  attributes :name, :bio, :cohort

  def cohort
    object.cohort.name
  end
end
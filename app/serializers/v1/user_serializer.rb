class V1::UserSerializer < V1::BaseSerializer
  attributes :id, :name, :email, :bio, :cohort_id, :profile

  def profile
    profile_attributes = {}
    User::Profile::ATTRIBUTES.each do |attr|
      profile_attributes[attr] = object.send(attr)
    end
    profile_attributes
  end
end

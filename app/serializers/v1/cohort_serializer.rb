class V1::CohortSerializer < V1::BaseSerializer
  attributes :name, :location, :start_date, :email, :in_session
  has_many :users, key: :students
end

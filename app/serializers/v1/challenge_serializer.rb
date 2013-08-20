class V1::ChallengeSerializer < V1::BaseSerializer
  attributes :id, :name, :description, :source_repo, :created_at, :updated_at
end

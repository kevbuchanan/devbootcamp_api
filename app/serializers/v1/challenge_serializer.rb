class V1::ChallengeSerializer < V1::BaseSerializer
  attributes :name, :description, :source_repo, :created_at, :updated_at
end

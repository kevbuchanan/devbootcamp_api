class V1::ApiKeySerializer < V1::BaseSerializer
  attributes :user_id, :key, :created_at, :updated_at
end

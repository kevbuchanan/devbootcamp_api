class V1::ChallengeAttemptSerializer < V1::BaseSerializer
  attributes :repo, :challenge_id, :finished_at
end

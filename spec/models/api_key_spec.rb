require 'spec_helper'

describe ApiKey do
  let (:user) {create :user }
  subject {ApiKey.create!(key: SecureRandom.hex, user: user)}

  it { should belong_to(:user) }
  it { should validate_presence_of(:key)}
  it { should validate_presence_of(:user_id)}
end

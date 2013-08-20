require 'spec_helper'

describe V1::ChallengeAttemptsController, :helper_namespace => :api_v1 do

  before(:each) do
    skip_http_authentication
    user = create :user
    challenge_attempt = create :challenge_attempt
    User.any_instance.stub(:challenge_attempts).and_return(challenge_attempt)
    ChallengeAttempt.any_instance.stub(:page).and_return([challenge_attempt])
    get :index, :user_id => user.id, :format => :json
  end

  describe '#index' do
    it_should_behave_like('an endpoint')

    it 'should return a list of challenge_attempts' do
      body = JSON.parse(response.body)
      repo = body['challenge_attempts'][0]['repo']
      expect(body['challenge_attempts']).to be_a(Array)
      expect(repo).to_not be_nil
    end
  end

  describe '#show' do

    before do
      user = create :user
      challenge_attempt = create :challenge_attempt
      User.any_instance.stub(:challenge_attempts).and_return(challenge_attempt)
      ChallengeAttempt.any_instance.stub(:find).and_return(challenge_attempt)
      get :show, :format => :json, :id => challenge_attempt.id, :user_id => user.id
    end

    it_should_behave_like('an endpoint')

    it 'should return one challenge_attempt' do
      body = JSON.parse(response.body)
      repo = body['challenge_attempt']['repo']
      expect(repo).to_not be_nil
    end

    it 'should return a 404 status if the user is not found' do
      get :show, :id => 0, :user_id => 0, :format => :json
      expect(response.status).to eql(404)
    end
  end
end

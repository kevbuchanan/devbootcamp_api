require 'spec_helper'

describe V1::ExerciseAttemptsController, :helper_namespace => :api_v1 do

  before(:each) do
    skip_http_authentication
    user = create :user
    exercise_attempt = create :exercise_attempt
    User.any_instance.stub(:exercise_attempts).and_return(exercise_attempt)
    exercise_attempt.stub(:correct).and_return(exercise_attempt)
    ExerciseAttempt.any_instance.stub(:page).and_return([exercise_attempt])
    get :index, :user_id => user.id, :format => :json
  end

  describe '#index' do
    it_should_behave_like('an endpoint')

    it 'should return a list of exercise_attempts' do
      body = JSON.parse(response.body)
      code = body['exercise_attempts'][0]['code']
      expect(body['exercise_attempts']).to be_a(Array)
      expect(code).to_not be_nil
    end
  end

  describe '#show' do

    before do
      user = create :user
      exercise_attempt = create :exercise_attempt
      User.any_instance.stub(:exercise_attempts).and_return(exercise_attempt)
      exercise_attempt.stub(:correct).and_return(exercise_attempt)
      ExerciseAttempt.any_instance.stub(:find).and_return(exercise_attempt)
      get :show, :format => :json, :id => exercise_attempt.id, :user_id => user.id
    end

    it_should_behave_like('an endpoint')

    it 'should return one exercise_attempt' do
      body = JSON.parse(response.body)
      code = body['exercise_attempt']['code']
      expect(code).to_not be_nil
    end

    it 'should return a 404 status if the user is not found' do
      get :show, :id => 0, :user_id => 0, :format => :json
      expect(response.status).to eql(404)
    end
  end
end

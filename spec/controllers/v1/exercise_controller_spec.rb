require 'spec_helper'

describe V1::ExercisesController, :helper_namespace => :api_v1 do

  before(:each) do
    skip_http_authentication
    create :exercise
    get :index, :format => :json
  end

  describe '#index' do
    it_should_behave_like('an endpoint')

    it 'should return a list of exercises' do
      body = JSON.parse(response.body)
      title = body['exercises'][0]['title']
      expect(body['exercises']).to be_a(Array)
      expect(title).to_not be_nil
    end
  end

  describe '#show' do

    context 'published exercise' do
      before do
        exercise = create :exercise
        get :show, :format => :json, :id => exercise.id
      end

      it_should_behave_like('an endpoint')

      it 'should return one exercise' do
        body = JSON.parse(response.body)
        title = body['exercise']['title']
        expect(title).to_not be_nil
      end

      it 'should return a 404 status if the exercise is not found' do
        get :show, :id => 0, :format => :json
        expect(response.status).to eql(404)
      end
    end

    context 'unpublished exercise' do
      it 'should not return an unpublished exercise' do
        exercise = create :unpublished_exercise
        get :show, :format => :json, :id => exercise.id
        expect(response.body).to eq ('{"message":"Record not found","more_info":"https://dev.devbootcamp.com/documentation#errors"}')
      end
    end
  end
end

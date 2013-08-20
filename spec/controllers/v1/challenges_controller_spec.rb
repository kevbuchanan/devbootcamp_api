require 'spec_helper'

describe V1::ChallengesController, :helper_namespace => :api_v1 do

  before(:each) do
    skip_http_authentication
    create :challenge
    get :index, :format => :json
  end

  describe '#index' do
    it_should_behave_like('an endpoint')

    it 'should return a list of challenges' do
      body = JSON.parse(response.body)
      name = body['challenges'][0]['name']
      expect(body['challenges']).to be_a(Array)
      expect(name).to_not be_nil
    end
  end

  describe '#show' do

    context 'published challenge' do
      before do
        challenge = create :challenge
        get :show, :format => :json, :id => challenge.id
      end

      it_should_behave_like('an endpoint')

      it 'should return one challenge' do
        body = JSON.parse(response.body)
        name = body['challenge']['name']
        expect(name).to_not be_nil
      end


      it 'should return a 404 status if the challenge is not found' do
        get :show, :id => 0, :format => :json
        expect(response.status).to eql(404)
      end
    end

    context 'unpublished challenge' do
      it 'should not return an unpublished challenge' do
        challenge = create :unpublished_challenge
        get :show, :format => :json, :id => challenge.id
        expect(response.body).to eq ('{"message":"Record not found","more_info":"https://dev.devbootcamp.com/documentation#errors"}')
      end
    end
  end
end

require 'spec_helper'

describe V1::ApiKeysController, :helper_namespace => :api_v1 do
  describe '#show' do
    before do
      user = create :user
      get :show, :format => :json, :id => user.id
    end

    it_should_behave_like('an endpoint')

    it 'should return an api key object' do
      body = JSON.parse(response.body)
      api_key = body['api_key']
      expect(api_key).to_not be_nil
    end

    it 'should return a 404 status if the user is not found' do
      get :show, :id => 0, :format => :json
      expect(response.status).to eql(404)
    end
  end
end

require 'spec_helper'

describe V1::UsersController, :helper_namespace => :api_v1 do

  before(:each) do
    #request.env['HTTP_AUTHORIZATION'] = 'Token token="foo"'
    #ApiKey.stub(:exists?).and_return(true)
    skip_http_authentication
  end

  describe '#index' do
    it_should_behave_like('an endpoint')


    it 'should return a list of users' do
      create :user
      get :index
      body = JSON.parse(response.body)
      name = body['users'][0]['name']
      expect(body['users']).to be_a(Array)
      expect(name).to_not be_nil
    end
  end

  describe '#show' do
    before do
      user = create :user
      get :show, :format => :json, :id => user.id
    end

    it_should_behave_like('an endpoint')

    it 'should return one user' do
      body = JSON.parse(response.body)
      name = body['name']
      expect(name).to_not be_nil
    end

    it 'should return a 404 status if the user is not found' do
      get :show, :id => 0, :format => :json
      expect(response.status).to eql(404)
    end
  end
end

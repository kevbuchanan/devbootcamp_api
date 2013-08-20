require 'spec_helper'

describe V1::CohortsController, :helper_namespace => :api_v1 do

  before(:each) do
    skip_http_authentication
    create :cohort
    get :index
  end

  describe '#index' do
    it_should_behave_like('an endpoint')

    it 'should return a list of cohorts' do
      body = JSON.parse(response.body)
      name = body['cohorts'][0]['name']
      expect(body['cohorts']).to be_a(Array)
      expect(name).to_not be_nil
    end
  end

  describe '#show' do
    before do
      cohort = create :cohort
      get :show, :format => :json, :id => cohort.id
    end

    it_should_behave_like('an endpoint')

    it 'should return one cohort' do
      body = JSON.parse(response.body)
      name = body['cohort']['name']
      expect(name).to_not be_nil
    end

    it 'should include a list of students' do
      body = JSON.parse(response.body)
      expect(body['cohort']).to have_key('students')
    end

    it 'should return a 404 status if the cohort is not found' do
      get :show, :id => 0, :format => :json
      expect(response.status).to eql(404)
    end
  end
end
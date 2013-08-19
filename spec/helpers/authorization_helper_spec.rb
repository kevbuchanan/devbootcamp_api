require 'spec_helper'

describe AuthorizationHelper do
  let(:user)    { create :user }
  let(:api_key) { user.key }

  describe "#valid_api_key?" do
    it "return true when request authorization header contains valid api key" do
      controller.request.stub(:headers).and_return({"Authorization" => "DBC-API #{user.key}"})
      expect(helper.valid_api_key?).to be_true
    end

    it "return false when request authorization header contains valid api key" do
      controller.request.stub(:headers).and_return({"Authorization" => "DBC-API foobar"})
      expect(helper.valid_api_key?).to be_false
    end
  end

  describe "#require_shared_key"

end
require 'spec_helper'

describe AuthorizationHelper do
  let(:user)    { User.create(name: "abi", password: 'pizza', password_confirmation: 'pizza') }
  let!(:api_key) { ApiKey.create(key: SecureRandom.hex, user: user) }

  describe "#valid_api_key?" do
    it "return true when request authorization header contains valid api key" do
      controller.request.stub(:headers).and_return({"Authorization" => "DBC-API #{user.key}"})
      expect(helper.valid_api_key?).to be_true
    end

    it "return false when request authorization header contains valid api key" do
      controller.request.stub(:headers).and_return({"Authorization" => "DBC-API foobar"})
      expect(helper.valid_api_key?).to be_false
    end

    it "return false when there is no authorization header in request" do
      controller.request.stub(:headers).and_return("Some-Other-Header" => "foobar")
      expect(helper.valid_api_key?).to be_false
    end

    it "should return false if authorization header is malformed" do
      controller.request.stub(:headers).and_return({"Authorization" => "foobar"})
      expect(helper.valid_api_key?).to be_false
    end
  end
end

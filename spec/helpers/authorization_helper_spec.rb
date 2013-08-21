require 'spec_helper'

describe AuthorizationHelper do
  let(:user)    { User.create(name: "abi", password: 'pizza', password_confirmation: 'pizza') }
  let!(:api_key) { ApiKey.create(key: SecureRandom.hex, user: user) }
  let(:shared_key) { 'test123' }

  describe "#valid_api_key?" do
    it "returns true when request authorization header contains valid api key" do
      controller.request.stub(:headers).and_return({"Authorization" => "DBC-API #{user.key}"})
      expect(helper.valid_api_key?).to be_true
    end

    it "returns false when request authorization header contains valid api key" do
      controller.request.stub(:headers).and_return({"Authorization" => "DBC-API foobar"})
      expect(helper.valid_api_key?).to be_false
    end

    it "returns false when there is no authorization header in request" do
      controller.request.stub(:headers).and_return("Some-Other-Header" => "foobar")
      expect(helper.valid_api_key?).to be_false
    end

    it "returns false if authorization header is malformed" do
      controller.request.stub(:headers).and_return({"Authorization" => "foobar"})
      expect(helper.valid_api_key?).to be_false
    end
  end

  describe "#valid_shared_key?" do
    before do
      ENV.stub(:[]).with("DBC-SHARED").and_return("test123")
    end

    it "returns true when request authorization header contains valid shared key" do
      controller.request.stub(:headers).and_return({"Authorization" => "DBC-SHARED #{shared_key}"})
      expect(helper.valid_shared_key?).to be_true
    end

    it "returns false when request authorization header contains valid api key" do
      controller.request.stub(:headers).and_return({"Authorization" => "DBC-SHARED foobar"})
      expect(helper.valid_shared_key?).to be_false
    end

    it "returns false when there is no authorization header in request" do
      controller.request.stub(:headers).and_return("Some-Other-Header" => "foobar")
      expect(helper.valid_shared_key?).to be_false
    end

    it "returns false if authorization header is malformed" do
      controller.request.stub(:headers).and_return({"Authorization" => "foobar"})
      expect(helper.valid_shared_key?).to be_false
    end
  end
end

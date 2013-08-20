# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include(FactoryGirl::Syntax::Methods)
  config.include V1::ApiHelper, :helper_namespace => :api_v1

  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

def skip_http_authentication
  V1::UsersController.any_instance.stub(:valid_api_key?).and_return(true)
  V1::CohortsController.any_instance.stub(:valid_api_key?).and_return(true)
  V1::ChallengesController.any_instance.stub(:valid_api_key?).and_return(true)
end

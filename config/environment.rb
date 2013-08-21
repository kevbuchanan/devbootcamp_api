# Load the rails application
require File.expand_path('../application', __FILE__)

DBC_SHARED_HEADER_LABEL = "DBC-SHARED"
# SHARED_KEY = ENV["DBC_SHARED"]
# Initialize the rails application
SocratesApi::Application.initialize!

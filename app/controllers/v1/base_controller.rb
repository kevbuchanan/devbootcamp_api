class V1::BaseController < ApplicationController
  include AuthorizationHelper

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  respond_to :json

  private

  def require_api_key
    render status: 401,
      		 json: {
        	   status: 401,
             message: "Invalid API key",
        		 more_info: "https://dev.devbootcamp.com/documentation#errors"
      		 } unless valid_api_key?
  end

  def render_404
	  render status: 404,
	     		 json: {
	           message: "Record not found",
	           more_info: "https://dev.devbootcamp.com/documentation#errors"}
	end
end

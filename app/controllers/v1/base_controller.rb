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
        		 more_info: DEV_SITE_HOST
      		 } unless valid_api_key?
  end

  def require_shared_key
    render status: 401,
       json: {
         status: 401,
         message: "Invalid Shared key",
         more_info: DEV_SITE_HOST
       } unless valid_shared_key?
  end

  def render_404
	  render status: 404,
	     		 json: {
	           message: "Record not found",
	           more_info: DEV_SITE_HOST}
	end
end

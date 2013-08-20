class V1::ChallengeAttemptsController < V1::BaseController
  include AuthorizationHelper

  before_filter :restrict_access
  respond_to :json

  def index
    user = User.find(params[:user_id])
    if user
      @challenge_attempts = user.challenge_attempts.all
      render json: @challenge_attempts
    else
      render nothing: true, status: 404
    end
  end

  def show
    user = User.find_by_id(params[:user_id])
    if user
      @challenge_attempts = user.challenge_attempts.find(params[:id])
      render json: @challenge_attempts
    else
      render nothing: true, status: 404
    end
  end

  private

  def restrict_access
    render(:nothing => true, :status => 404) unless valid_api_key?
  end
end

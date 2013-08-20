class V1::ChallengesController < V1::BaseController
  include AuthorizationHelper

  before_filter :restrict_access
  respond_to :json

  def index
    @challenges = Challenge.published.all
    render json: @challenges
  end

  def show
    @challenge = Challenge.published.find_by_id(params[:id])
    if @challenge
      render json: @challenge
    else
      render nothing: true, status: 404
    end
  end

  private

  def restrict_access
    render(:nothing => true, :status => 404) unless valid_api_key?
  end
end
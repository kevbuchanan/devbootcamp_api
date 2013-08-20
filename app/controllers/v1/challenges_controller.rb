class V1::ChallengesController < V1::BaseController
  include AuthorizationHelper

  before_filter :restrict_access
  respond_to :json

  def index
    @challenges = Challenge.published.page({page: params[:page], per_page: params[:per_page]})
    render json: @challenges
  end

  def show
    @challenge = Challenge.published.find_by_id(params[:id])
    if @challenge
      render json: @challenge
    else
      render(
        :status => 404,
        json:{
          :message => "Challenge not found",
          :more_info => "http://errorpage.com"})
    end
  end

  private

  def restrict_access
    render(
      :status => 401,
      json:{
        :status => 401,
        :message => "Need valid API key",
        :more_info => "http://www.errorpage.com"
      }) unless valid_api_key?
  end
end

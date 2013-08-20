class V1::ChallengeAttemptsController < V1::BaseController

  def index
    user = User.find(params[:user_id])
    respond_with user.challenge_attempts.page({page: params[:page], per_page: params[:per_page]})
  end

  def show
    user = User.find(params[:user_id])
    respond_with user.challenge_attempts.find(params[:id])
  end
end

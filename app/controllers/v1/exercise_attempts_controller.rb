class V1::ExerciseAttemptsController < V1::BaseController
  before_filter :require_api_key
  def index
    user = User.find(params[:user_id])
    respond_with user.exercise_attempts.correct.page({page: params[:page], per_page: params[:per_page]})
  end

  def show
    user = User.find(params[:user_id])
    respond_with user.exercise_attempts.correct.find(params[:id])
  end
end

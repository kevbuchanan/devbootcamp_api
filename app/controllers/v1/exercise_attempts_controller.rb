class V1::ExerciseAttemptsController < V1::BaseController
  include AuthorizationHelper

  before_filter :restrict_access
  respond_to :json

  def index
    user = User.find(params[:user_id])
    if user
      @exercise_attempts = user.exercise_attempts.correct.all
      render json: @exercise_attempts
    else
      render nothing: true, status: 404
    end
  end

  def show
    user = User.find(params[:user_id])
    if user
      @exercise_attempts = user.exercise_attempts.correct.find(params[:id])
      render json: @exercise_attempts
    else
      render nothing: true, status: 404
    end
  end

  private

  def restrict_access
    render(:nothing => true, :status => 404) unless valid_api_key?
  end
end
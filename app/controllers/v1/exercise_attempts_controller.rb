class V1::ExerciseAttemptsController < V1::BaseController
  include AuthorizationHelper

  before_filter :restrict_access
  respond_to :json

  def index
    user = User.find(params[:user_id])
    if user
      @exercise_attempts = user.exercise_attempts.correct.page({page: params[:page], per_page: params[:per_page]})
      render json: @exercise_attempts
    else
      render(
        :status => 404,
        json:{
          :message => "User not found",
          :more_info => "http://errorpage.com"})
    end
  end

  def show
    user = User.find(params[:user_id])
    if user
      @exercise_attempts = user.exercise_attempts.correct.find(params[:id])
      render json: @exercise_attempts
    else
      render(
        :status => 404,
        json:{
          :message => "User not found",
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

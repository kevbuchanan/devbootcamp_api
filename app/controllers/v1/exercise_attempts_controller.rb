class V1::ExerciseAttemptsController < V1::BaseController
  def index
    user = User.find(params[:user_id])

    # if user
      # exercise_attempts = user.exercise_attempts.correct.page({page: params[:page], per_page: params[:per_page]})
      # render json: exercise_attempts
      respond_with user.exercise_attempts.correct.page({page: params[:page], per_page: params[:per_page]})
    # else
    #   render(
    #     :status => 404,
    #     json:{
    #       :message => "User not found",
    #       :more_info => "http://errorpage.com"})
    # end
  end

  def show
    user = User.find(params[:user_id])

    # if user
      # exercise_attempts = user.exercise_attempts.correct.find(params[:id])
      # render json: exercise_attempts
      respond_with user.exercise_attempts.correct.find(params[:id])
    # else
    #   render(
    #     :status => 404,
    #     json:{
    #       :message => "User not found",
    #       :more_info => "http://errorpage.com"})
    # end
  end
end

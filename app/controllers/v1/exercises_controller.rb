class V1::ExercisesController < V1::BaseController
  include AuthorizationHelper

  before_filter :restrict_access
  respond_to :json

  def index
    @exercises = Exercise.published.page({page: params[:page], per_page: params[:per_page]})
    render json: @exercises
  end

  def show
    @exercise = Exercise.published.find(params[:id])
    if @exercise
      render json: @exercise
    else
      render(
        :status => 404,
        json:{
          :message => "Exercise not found",
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

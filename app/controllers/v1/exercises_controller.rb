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
      render nothing: true, status: 404
    end
  end

  private

  def restrict_access
    render(:nothing => true, :status => 404) unless valid_api_key?
  end
end

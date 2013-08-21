class V1::ExercisesController < V1::BaseController
  before_filter :require_api_key
  def index
    respond_with Exercise.published
  end

  def show
    respond_with Exercise.published.find(params[:id])
  end
end

class V1::ExercisesController < V1::BaseController

  def index
    respond_with Exercise.published
  end

  def show
    respond_with Exercise.published.find(params[:id])
  end
end

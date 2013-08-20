class V1::CohortsController < V1::BaseController

  def index
    respond_with Cohort.page({page: params[:page], per_page: params[:per_page]})
  end

  def show
    respond_with Cohort.find(params[:id])
  end
end

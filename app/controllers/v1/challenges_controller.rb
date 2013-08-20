class V1::ChallengesController < V1::BaseController

  def index
    respond_with Challenge.published.page({page: params[:page], per_page: params[:per_page]})
  end

  def show
    respond_with Challenge.published.find(params[:id])
  end
end

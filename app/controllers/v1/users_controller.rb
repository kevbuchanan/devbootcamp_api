class V1::UsersController < V1::BaseController
  before_filter :require_api_key
  def index
    respond_with User.all
  end

  def show
    respond_with User.find(params[:id])
  end
end

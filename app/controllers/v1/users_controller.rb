class V1::UsersController < V1::BaseController

  def index
    respond_with User.all
  end

  def show
    respond_with User.find(params[:id])
  end
end

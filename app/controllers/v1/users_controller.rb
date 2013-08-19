class V1::UsersController < V1::BaseController
  before_filter :restrict_access
  respond_to :json

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user
      render json: @user
    else
      render nothing: true, status: 404
    end
  end

  def update
  end

  def destroy
  end

  def create
  end

  private

  def restrict_access
    render(:nothing => true, :status => 404) unless valid_api_key?
  end
end

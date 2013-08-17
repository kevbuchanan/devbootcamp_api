class V1::UsersController < V1::BaseController
  before_filter :restrict_access

  respond_to :json

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user
      respond_with @user
    else
      redirect_to(status: 404)
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
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(key: token)
    end
  end
end

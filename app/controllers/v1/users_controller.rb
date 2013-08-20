class V1::UsersController < V1::BaseController
  include AuthorizationHelper

  before_filter :restrict_access
  respond_to :json

  def index
    @users = User.page({page: params[:page], per_page: params[:per_page]})
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

  private

  def restrict_access
    render(:nothing => true, :status => 404) unless valid_api_key?
  end
end

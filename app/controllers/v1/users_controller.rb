module V1
  class UsersController < BaseController
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
        ApiKey.exists?(access_token: token)
      end
    end
  end
end

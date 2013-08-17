class V1::ApiKeysController < V1::BaseController
  respond_to :json

  def show
    @key = ApiKey.find_by_user_id(params[:id])
    if @key
      respond_with @key
    else
      redirect_to(status: 404)
    end
  end
end
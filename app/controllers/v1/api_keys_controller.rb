class V1::ApiKeysController < V1::BaseController
  before_filter :restrict_access
  respond_to :json

  def show
    @key = ApiKey.find_by_user_id(params[:id])
    if @key
      respond_with @key
    else
      redirect_with(status: 404)
    end
  end

  private

  def restrict_access
    redirect_with(status: 404) unless request.headers['Authorization'] == 'DBC-API test'
  end
end
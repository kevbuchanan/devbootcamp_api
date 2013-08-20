class V1::ApiKeysController < V1::BaseController
  before_filter :restrict_access
  respond_to :json

  def show
    api_key = ApiKey.find_by_user_id(params[:id])

    if api_key
      render json: api_key
    else
      render nothing: true, status: 404
    end
  end

  private

  def restrict_access
    render(:nothing => true, :status => 404) unless request.headers['Authorization'] == ENV['DBC_SHARED']
  end
end
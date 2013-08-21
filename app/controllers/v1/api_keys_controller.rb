class V1::ApiKeysController < V1::BaseController
  before_filter :require_shared_key

  def show
    respond_with ApiKey.find_by_user_id!(params[:id])
  end
end

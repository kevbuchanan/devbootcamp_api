class V1::ApiKeysController < V1::BaseController
  def show
    respond_with ApiKey.find_by_user_id!(params[:id])

    # if api_key
    #   render json: api_key
    # else
    #   render nothing: true, status: 404
    # end
  end

end

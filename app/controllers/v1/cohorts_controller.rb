class V1::CohortsController < V1::BaseController
  include AuthorizationHelper

  before_filter :restrict_access
  respond_to :json

  def index
    @cohorts = Cohort.all
    render json: @cohorts
  end

  def show
    @cohort = Cohort.find_by_id(params[:id])
    if @cohort
      render json: @cohort
    else
      render nothing: true, status: 404
    end
  end

  private

  def restrict_access
    render(:nothing => true, :status => 404) unless valid_api_key?
  end
end

class V1::CohortsController < V1::BaseController
  include AuthorizationHelper

  before_filter :restrict_access
  respond_to :json

  def index
    @cohorts = Cohort.page({page: params[:page], per_page: params[:per_page]})
    render json: @cohorts
  end

  def show
    @cohort = Cohort.find_by_id(params[:id])
    if @cohort
      render json: @cohort
    else
      render(
        :status => 404,
        json:{
          :message => "Cohort not found",
          :more_info => "http://errorpage.com"})
    end
  end

  private

  def restrict_access
    render(
      :status => 401,
      json:{
        :status => 401,
        :message => "Need valid API key",
        :more_info => "http://www.errorpage.com"
      }) unless valid_api_key?
  end
end

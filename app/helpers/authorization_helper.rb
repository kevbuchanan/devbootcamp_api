module AuthorizationHelper
  def valid_api_key?
    p request.headers
    compare_keys
    controller.request.header =

  end

  private


  def compare_keys
    controller.request.header == user.key
  end

end
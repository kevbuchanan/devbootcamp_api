module AuthorizationHelper
  def valid_api_key?
    auth_header && auth_header_format_valid? && api_key_exists?
  end

  def valid_shared_key?
    auth_header == DBC_SHARED_HEADER_LABEL + " " + shared_key
  end

  private

  def auth_header
    request.headers["Authorization"]
  end

  def auth_header_parts
    auth_header.split(' ')
  end

  def auth_header_key
    auth_header_parts.last
  end

  def auth_header_format_valid?
    auth_header_parts.count == 2 && auth_header_parts.first == "DBC-API"
  end

  def api_key_exists?
    ApiKey.find_by_key(auth_header_key) != nil
  end

  def shared_key
    SHARED_KEY
  end
end

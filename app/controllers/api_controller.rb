class ApiController < ActionController::API
  include ::JsonErrorSerializer::Extenders::Controller
  include Decryptor
  include Authenticator

  before_action :set_default_response_format
  before_action :per_request

  protected

  def set_default_response_format
    request.format = :json
  end

  private

  def per_request
    $encryption_enable = false
    $session_key = find_session_key
    $params = decrypt_params
  end
end

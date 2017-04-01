class ApiController < ApplicationController
  include JsonErrorSerializer::Extenders::Controller
  include Decryptor
  include Checker
  include Authenticator

  before_action :set_default_response_format
  before_action :per_request, except: [:get_public, :send_public]

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
